# frozen_string_literal: true

# == Schema Information
#
# Table name: rubygem_trends
#
#  id                       :bigint           not null, primary key
#  date                     :date             not null
#  position                 :integer          not null
#  rubygem_name             :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  rubygem_download_stat_id :integer          not null
#
# Indexes
#
#  index_rubygem_trends_on_date               (date)
#  index_rubygem_trends_on_date_and_position  (date,position) UNIQUE
#  index_rubygem_trends_on_position           (position)
#
# Foreign Keys
#
#  fk_rails_...  (rubygem_download_stat_id => rubygem_download_stats.id)
#  fk_rails_...  (rubygem_name => rubygems.name)
#
class Rubygem::Trend < ApplicationRecord
  belongs_to :rubygem,
             primary_key: :name,
             foreign_key: :rubygem_name,
             inverse_of:  :trends

  belongs_to :rubygem_download_stat,
             class_name: "Rubygem::DownloadStat",
             inverse_of: :trends

  has_one :project, through: :rubygem
  has_one :github_repo, through: :project

  delegate :absolute_change_month,
           :relative_change_month,
           :growth_change_month,
           to: :rubygem_download_stat

  def self.with_associations
    includes(:rubygem_download_stat, project: %i[rubygem github_repo])
      .joins(:rubygem_download_stat, project: %i[rubygem github_repo])
  end

  def self.latest
    for_date maximum(:date)
  end

  def self.for_date(date)
    where(date: date)
      .with_associations
      .order(position: :asc)
  end
end
