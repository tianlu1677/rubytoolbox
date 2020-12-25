# frozen_string_literal: true

# == Schema Information
#
# Table name: rubygems
#
#  authors                    :string
#  bug_tracker_url            :string
#  changelog_url              :string
#  current_version            :string           not null
#  description                :text
#  documentation_url          :string
#  downloads                  :integer          not null
#  fetched_at                 :datetime
#  first_release_on           :date
#  homepage_url               :string
#  latest_release_on          :date
#  licenses                   :string           default([]), is an Array
#  mailing_list_url           :string
#  name                       :string           not null, primary key
#  quarterly_release_counts   :jsonb            not null
#  releases_count             :integer
#  reverse_dependencies_count :integer
#  source_code_url            :string
#  wiki_url                   :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_rubygems_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe Rubygem, type: :model do
  describe ".update_batch" do
    before do
      described_class.create! name: "up-to-date", downloads: 50, current_version: "1.0.0", updated_at: 23.hours.ago
      described_class.create! name: "outdated1", downloads: 50, current_version: "1.0.0", updated_at: 27.hours.ago
      described_class.create! name: "outdated2", downloads: 50, current_version: "1.0.0", updated_at: 26.hours.ago
    end

    it "contains a subset of gems that should be updated" do
      expect(described_class.update_batch).to match %w[outdated1]
    end

    it "the subset grows with to the total count of gems" do
      24.times do |i|
        described_class.create! name:            "outdated#{i + 3}",
                                downloads:       50,
                                current_version: "1.0.0",
                                updated_at:      25.hours.ago
      end

      expect(described_class.update_batch).to match %w[outdated1 outdated2]
    end
  end

  describe "#url" do
    it "is derived from the gem name" do
      expect(described_class.new(name: "foobar").url).to be == "https://rubygems.org/gems/foobar"
    end
  end

  describe "#documentation_url" do
    it "is the gem's documentation_url if set" do
      url = "https://api.rubyonrails.org"
      expect(described_class.new(documentation_url: url).documentation_url).to be == url
    end

    it "falls back to rubydoc.info if not set in gem metadata" do
      expected = "http://www.rubydoc.info/gems/rails/frames"
      expect(described_class.new(name: "rails").documentation_url).to be == expected
    end
  end
end
