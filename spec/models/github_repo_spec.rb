# frozen_string_literal: true

# == Schema Information
#
# Table name: github_repos
#
#  archived                     :boolean
#  average_recent_committed_at  :datetime
#  closed_issues_count          :integer
#  closed_pull_requests_count   :integer
#  code_of_conduct_name         :string
#  code_of_conduct_url          :string
#  default_branch               :string
#  description                  :string
#  fetched_at                   :datetime
#  forks_count                  :integer          not null
#  has_issues                   :boolean
#  has_wiki                     :boolean
#  homepage_url                 :string
#  is_fork                      :boolean
#  is_mirror                    :boolean
#  issue_closure_rate           :decimal(5, 2)
#  license                      :string
#  merged_pull_requests_count   :integer
#  open_issues_count            :integer
#  open_pull_requests_count     :integer
#  path                         :citext           not null, primary key
#  primary_language             :string
#  pull_request_acceptance_rate :decimal(5, 2)
#  repo_created_at              :datetime
#  repo_pushed_at               :datetime
#  stargazers_count             :integer          not null
#  topics                       :string           default([]), not null, is an Array
#  total_issues_count           :integer
#  total_pull_requests_count    :integer
#  watchers_count               :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_github_repos_on_path  (path) UNIQUE
#
require "rails_helper"

RSpec.describe GithubRepo, type: :model do
  def create_repo!(path:, updated_at: 1.day.ago)
    GithubRepo.create! path:             path,
                       updated_at:       updated_at,
                       stargazers_count: 1,
                       watchers_count:   1,
                       forks_count:      1
  end

  describe ".update_batch" do
    before do
      create_repo! path: "foo/up-to-date", updated_at: 23.hours.ago
      create_repo! path: "foo/outdated1", updated_at: 27.hours.ago
      create_repo! path: "foo/outdated2", updated_at: 26.hours.ago
    end

    it "contains a subset of repos that should be updated" do
      expect(described_class.update_batch).to match %w[foo/outdated1]
    end

    it "the subset grows with to the total count of repos" do
      24.times do |i|
        create_repo! path: "foo/outdated#{i + 3}", updated_at: 25.hours.ago
      end

      expect(described_class.update_batch).to match %w[foo/outdated1 foo/outdated2]
    end
  end

  describe ".without_projects" do
    before do
      create_repo! path: "foo/linked"
      Project.create! permalink: "foo/linked", github_repo_path: "foo/linked"
      create_repo! path: "foo/orphaned"
    end

    it "contains records without associated projects" do
      expect(described_class.without_projects.pluck(:path)).to be == %w[foo/orphaned]
    end
  end

  describe "#path=" do
    it "normalizes the path to the stripped, downcase variant" do
      expect(described_class.new(path: " FoO/BaR ").path).to be == "foo/bar"
    end
  end

  describe "#url" do
    it "is derived from the repo path" do
      expect(described_class.new(path: "foo/bar").url).to be == "https://github.com/foo/bar"
    end
  end

  describe "#blob_url" do
    it "is derived from the repo path and default_branch" do
      expect(described_class.new(path: "foo/bar", default_branch: "main").blob_url).to be == "https://github.com/foo/bar/blob/main"
    end

    it "is nil when there is no default_branch" do
      expect(described_class.new(path: "foo/bar", default_branch: nil).blob_url).to be nil
    end
  end

  describe "#wiki_url" do
    it "is nil when has_wiki is false" do
      expect(described_class.new(has_wiki: false).wiki_url).to be_nil
    end

    it "is derived from repo path when has_wiki is true" do
      expected_url = "https://github.com/foo/bar/wiki"
      expect(described_class.new(path: "foo/bar", has_wiki: true).wiki_url).to be == expected_url
    end
  end

  describe "#issues_url" do
    it "is nil when has_issues is false" do
      expect(described_class.new(has_issues: false).issues_url).to be_nil
    end

    it "is derived from repo path when has_issues is true" do
      expected_url = "https://github.com/foo/bar/issues"
      expect(described_class.new(path: "foo/bar", has_issues: true).issues_url).to be == expected_url
    end
  end

  describe "#sibling_gem_with_most_downloads" do
    it "returns rubygem that has the most downloads and same repo" do
      widget = Factories.project "widget", downloads: 50_000
      other = Factories.project "other", downloads: 10_000
      other.update! github_repo: widget.github_repo

      expect(other.github_repo.sibling_gem_with_most_downloads).to be == widget.rubygem
    end
  end
end
