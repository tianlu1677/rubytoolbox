# frozen_string_literal: true

# == Schema Information
#
# Table name: rubygem_download_stats
#
#  id                    :bigint           not null, primary key
#  absolute_change_month :integer
#  date                  :date             not null
#  growth_change_month   :decimal(, )
#  relative_change_month :decimal(, )
#  rubygem_name          :string           not null
#  total_downloads       :integer          not null
#
# Indexes
#
#  index_rubygem_download_stats_on_absolute_change_month  (absolute_change_month)
#  index_rubygem_download_stats_on_date                   (date)
#  index_rubygem_download_stats_on_growth_change_month    (growth_change_month)
#  index_rubygem_download_stats_on_relative_change_month  (relative_change_month)
#  index_rubygem_download_stats_on_rubygem_name_and_date  (rubygem_name,date) UNIQUE
#  index_rubygem_download_stats_on_total_downloads        (total_downloads)
#
# Foreign Keys
#
#  fk_rails_...  (rubygem_name => rubygems.name)
#
#
# This class represents historical rubygem download data for a given date and gem.
#
# We only store weekly stats, on sundays, to make calculations between timeframes
# more consistent and easy to reason about, as well as saving on database storage
# massively. For the Ruby Toolbox's purposes, weekly stats are just fine(tm).
#
# The weekly persistence of stats happens via the `RubygemDownloadsPersistenceJob`,
# which takes a snapshot of whatever current downloads are stored on the `rubygems`
# table (if gem data updating is broken this might be outdated, but again on the
# average week the assumption is that this is good enough for our purposes).
#
# A number of additional stats is calculated using postgres trigger functions, based
# on the presence of previous data:
#
# `absolute_change_(week|month|year)`:
#   The total number of downloads just in that timeframe (if previous record is there)
#
# `relative_change_(week|month|year)`:
#   The percentage of all-time total downloads the timeframe's absolute downloads constitute
#
# `growth_change_(week|month|year)`:
#   The difference between current relative change and the previous one in the timeframe
#
# The trigger functions are not "clever" in triggering related updates if a historical record
# changes (since the assumption is they won't change anyway, it's historical data after all).
# If you change historical numbers, be sure to trigger a re-calculation of all related stats by
# issuing `UPDATE rubygem_download_stats SET id = id (WHERE rubygem_name = 'foo')".
#
class Rubygem::DownloadStat < ApplicationRecord
  belongs_to :rubygem,
             primary_key: :name,
             foreign_key: :rubygem_name,
             inverse_of:  :download_stats

  has_one :project, through: :rubygem

  has_many :trends, class_name:  "Rubygem::Trend",
                    foreign_key: :rubygem_download_stat_id,
                    inverse_of:  :rubygem_download_stat,
                    dependent:   :destroy

  def self.monthly(base_date: Rubygem::DownloadStat.maximum(:date))
    where("(#{table_name}.date <= ?)", base_date)
      .where("(#{table_name}.date - ?) % 28 = 0", base_date)
  end

  def self.with_associations
    includes(:rubygem, :project)
      .joins(:rubygem, :project)
  end
end
