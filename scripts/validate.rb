#!/usr/bin/env ruby

require "json"
require "yaml"
require "set"

ROOT = File.expand_path("..", __dir__)
ALLOWED_POSITIONS = Set.new(%w[
  support support_with_conditions oppose abstain insufficient_evidence outside_domain
]).freeze
ALLOWED_STATES = Set.new(%w[
  open under_review deliberating recommendation_ready human_review closed deferred rejected
]).freeze

errors = []

def load_yaml(path, errors)
  YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: true) || {}
rescue StandardError => e
  errors << "#{path}: invalid YAML (#{e.message})"
  {}
end

def load_json(path, errors)
  JSON.parse(File.read(path))
rescue StandardError => e
  errors << "#{path}: invalid JSON (#{e.message})"
  {}
end

Dir[File.join(ROOT, "**", "*.yaml")].sort.each { |path| load_yaml(path, errors) }
Dir[File.join(ROOT, "**", "*.json")].sort.each { |path| load_json(path, errors) }

rules_path = File.join(ROOT, "institution", "decision-rules.yaml")
rules = load_yaml(rules_path, errors)
unless Set.new(rules.fetch("allowed_positions", [])) == ALLOWED_POSITIONS
  errors << "#{rules_path}: allowed_positions does not match the v0.1 contract"
end
unless Set.new(rules.fetch("institutional_states", [])) == ALLOWED_STATES
  errors << "#{rules_path}: institutional_states does not match the v0.1 contract"
end

committee_ids = Set.new
Dir[File.join(ROOT, "committees", "*.yaml")].sort.each do |path|
  data = load_yaml(path, errors)
  committee = data.fetch("committee", {})
  id = committee["id"]
  errors << "#{path}: missing committee.id" if id.nil? || id.empty?
  errors << "#{path}: duplicate committee.id #{id}" if id && committee_ids.include?(id)
  committee_ids << id if id
  %w[cite_evidence expose_uncertainty identify_missing_stakeholders allow_abstention allow_outside_domain].each do |rule|
    errors << "#{path}: rules.#{rule} must be true" unless data.dig("rules", rule) == true
  end
end

case_ids = Set.new
all_evidence_ids = Set.new
Dir[File.join(ROOT, "cases", "**", "case.yaml")].sort.each do |path|
  data = load_yaml(path, errors)
  id = data["case_id"]
  errors << "#{path}: missing case_id" if id.nil? || id.empty?
  errors << "#{path}: duplicate case_id #{id}" if id && case_ids.include?(id)
  case_ids << id if id
  state = data["status"]
  errors << "#{path}: invalid status #{state.inspect}" unless ALLOWED_STATES.include?(state)

  evidence_path = File.join(File.dirname(path), "evidence.yaml")
  next unless File.exist?(evidence_path)

  evidence_data = load_yaml(evidence_path, errors)
  evidence_ids = Set.new
  evidence_data.fetch("evidence", []).each do |item|
    evidence_id = item["evidence_id"]
    source_id = item["source_id"]
    errors << "#{evidence_path}: evidence item missing evidence_id" if evidence_id.nil? || evidence_id.empty?
    errors << "#{evidence_path}: duplicate evidence_id #{evidence_id}" if evidence_id && evidence_ids.include?(evidence_id)
    evidence_ids << evidence_id if evidence_id
    all_evidence_ids << evidence_id if evidence_id
    errors << "#{evidence_path}: #{evidence_id || 'item'} missing source_id" if source_id.nil? || source_id.empty?
  end

  referenced_ids = Set.new(data.fetch("evidence", []))
  (referenced_ids - evidence_ids).each do |missing_id|
    errors << "#{path}: references missing evidence ID #{missing_id}"
  end

  sources_path = File.join(File.dirname(path), "sources.yaml")
  if File.exist?(sources_path)
    source_data = load_yaml(sources_path, errors)
    source_ids = Set.new
    source_data.fetch("sources", []).each do |item|
      source_id = item["source_id"]
      errors << "#{sources_path}: source item missing source_id" if source_id.nil? || source_id.empty?
      errors << "#{sources_path}: duplicate source_id #{source_id}" if source_id && source_ids.include?(source_id)
      source_ids << source_id if source_id
    end
    evidence_data.fetch("evidence", []).each do |item|
      source_id = item["source_id"]
      errors << "#{evidence_path}: references missing source ID #{source_id}" if source_id && !source_ids.include?(source_id)
    end
  end
end

Dir[File.join(ROOT, "outputs", "**", "*.json")].sort.reject { |path| path.include?("/failures/") }.each do |path|
  data = load_json(path, errors)
  if data.key?("position")
    committee = data["committee"]
    errors << "#{path}: committee must be a configured committee ID" unless committee_ids.include?(committee)
    position = data["position"]
    errors << "#{path}: invalid position #{position.inspect}" unless ALLOWED_POSITIONS.include?(position)
    confidence = data["confidence"]
    errors << "#{path}: confidence must be between 0 and 1" unless confidence.is_a?(Numeric) && confidence.between?(0, 1)
    %w[evidence interpretation stakeholders_considered concerns missing_evidence].each do |field|
      errors << "#{path}: #{field} must be an array" unless data[field].is_a?(Array)
    end
    Set.new(data.fetch("evidence", [])).each do |evidence_id|
      errors << "#{path}: references missing evidence ID #{evidence_id}" unless all_evidence_ids.include?(evidence_id)
    end
  elsif data.key?("agreement")
    %w[agreement disagreement cross_disciplinary_effects missing_evidence missing_stakeholders minority_positions conditions].each do |field|
      errors << "#{path}: #{field} must be an array" unless data[field].is_a?(Array)
    end
    confidence = data["confidence"]
    errors << "#{path}: confidence must be between 0 and 1" unless confidence.is_a?(Numeric) && confidence.between?(0, 1)
    errors << "#{path}: recommendation must be a non-empty string" unless data["recommendation"].is_a?(String) && !data["recommendation"].empty?
  end
end

Dir[File.join(ROOT, "**", "*.yaml")].sort.each do |path|
  data = load_yaml(path, errors)
  next unless data.key?("decision_id")
  errors << "#{path}: human_review must be required" unless data["human_review"] == "required"
  confidence = data["confidence"]
  errors << "#{path}: confidence must be between 0 and 1" unless confidence.is_a?(Numeric) && confidence.between?(0, 1)
  state = data["institutional_status"]
  errors << "#{path}: invalid institutional_status #{state.inspect}" unless ALLOWED_STATES.include?(state)
  Set.new(data.fetch("evidence_used", [])).each do |evidence_id|
    errors << "#{path}: references missing evidence ID #{evidence_id}" unless all_evidence_ids.include?(evidence_id)
  end
end

if errors.empty?
  puts "PASS: Synthetic Arts Council v0.1 contracts are structurally valid."
  exit 0
end

warn "FAIL: #{errors.length} validation error(s):"
errors.each { |error| warn "- #{error}" }
exit 1
