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
class Rubygem < ApplicationRecord
  self.primary_key = :name

  has_one :project,
          primary_key: :name,
          foreign_key: :rubygem_name,
          inverse_of:  :rubygem,
          dependent:   :destroy

  has_many :download_stats, -> { order(date: :asc) },
           class_name:  "Rubygem::DownloadStat",
           primary_key: :name,
           foreign_key: :rubygem_name,
           inverse_of:  :rubygem,
           dependent:   :destroy

  has_many :trends, -> { order(date: :asc) },
           class_name:  "Rubygem::Trend",
           primary_key: :name,
           foreign_key: :rubygem_name,
           inverse_of:  :rubygem,
           dependent:   :destroy

  def self.update_batch
    where("updated_at < ? ", 24.hours.ago.utc)
      .order(updated_at: :asc)
      .limit((count / 24.0).ceil)
      .pluck(:name)
  end

  def url
    File.join "https://rubygems.org/gems", name
  end

  def documentation_url
    super.presence || File.join("http://www.rubydoc.info/gems", name, "frames")
  end
end
