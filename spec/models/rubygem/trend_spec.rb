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
require "rails_helper"

RSpec.describe Rubygem::Trend, type: :model do
  describe ".for_date" do
    before do
      Factories.project "a"
      Factories.project "b"
      Factories.project "c"

      Factories.rubygem_trend "a", date: Time.current, position: 2
      Factories.rubygem_trend "b", date: Time.current, position: 1
      Factories.rubygem_trend "c", date: 1.week.ago, position: 1
    end

    it "returns matching records for given date by position" do
      expect(described_class.for_date(Time.current).pluck(:rubygem_name)).to be == %w[b a]
    end

    it "deeply eager-loads associations" do
      n_plus_one = ->(t) { [t.project.github_repo_path, t.project.rubygem.name] }
      query = -> { described_class.for_date(Time.current).map(&n_plus_one) }
      query.call # Dry-run to prevent activerecord schema query sprinkles

      expect(&query).to make_database_queries(count: 1)
    end

    it "allows cascading deletion of a rubygem when it's gone" do
      expect(Rubygem.find("a").destroy).to be_truthy
    end
  end
end
