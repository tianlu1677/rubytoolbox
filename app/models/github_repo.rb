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
class GithubRepo < ApplicationRecord
  self.primary_key = :path

  has_many :projects,
           primary_key: :path,
           foreign_key: :github_repo_path,
           inverse_of:  :github_repo,
           dependent:   :nullify

  has_many :rubygems,
           through: :projects

  has_one :readme,
          primary_key: :path,
          foreign_key: :path,
          inverse_of:  :github_repo,
          class_name:  "Github::Readme",
          dependent:   :destroy

  delegate :html,
           :etag,
           to:        :readme,
           allow_nil: true,
           prefix:    :readme

  def self.update_batch
    where("updated_at < ? ", 24.hours.ago.utc)
      .order(updated_at: :asc)
      .limit((count / 24.0).ceil)
      .pluck(:path)
  end

  def self.without_projects
    joins("LEFT JOIN projects ON projects.github_repo_path = github_repos.path")
      .where(projects: { permalink: nil })
  end

  def path=(path)
    super Github.normalize_path(path)
  end

  def url
    File.join "https://github.com", path
  end

  def blob_url
    return unless default_branch

    File.join url, "blob", default_branch
  end

  def issues_url
    File.join(url, "issues") if has_issues?
  end

  def pull_requests_url
    File.join(url, "pulls")
  end

  def wiki_url
    File.join(url, "wiki") if has_wiki?
  end

  def sibling_gem_with_most_downloads
    rubygems.order(downloads: :desc).first
  end
end
