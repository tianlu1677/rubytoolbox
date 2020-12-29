# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_30_205823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "categories", id: false, force: :cascade do |t|
    t.citext "permalink", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.citext "category_group_permalink", null: false
    t.tsvector "name_tsvector"
    t.integer "rank"
    t.tsvector "description_tsvector"
    t.index ["category_group_permalink"], name: "index_categories_on_category_group_permalink"
    t.index ["created_at"], name: "index_categories_on_created_at"
    t.index ["description_tsvector"], name: "index_categories_on_description_tsvector", using: :gin
    t.index ["name_tsvector"], name: "index_categories_on_name_tsvector", using: :gin
    t.index ["permalink"], name: "index_categories_on_permalink", unique: true
    t.index ["rank"], name: "index_categories_on_rank"
  end

  create_table "categorizations", force: :cascade do |t|
    t.citext "category_permalink", null: false
    t.string "project_permalink", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_permalink", "project_permalink"], name: "categorizations_unique_index", unique: true
    t.index ["category_permalink"], name: "index_categorizations_on_category_permalink"
    t.index ["project_permalink"], name: "index_categorizations_on_project_permalink"
  end

  create_table "category_groups", id: false, force: :cascade do |t|
    t.citext "permalink", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permalink"], name: "index_category_groups_on_permalink", unique: true
  end

  create_table "github_ignores", id: false, force: :cascade do |t|
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_github_ignores_on_path", unique: true
  end

  create_table "github_readmes", id: false, force: :cascade do |t|
    t.string "path", null: false
    t.text "html", null: false
    t.string "etag", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["path"], name: "index_github_readmes_on_path", unique: true
  end

  create_table "github_repos", id: false, force: :cascade do |t|
    t.citext "path", null: false
    t.integer "stargazers_count", null: false
    t.integer "forks_count", null: false
    t.integer "watchers_count", null: false
    t.string "description"
    t.string "homepage_url"
    t.datetime "repo_created_at"
    t.datetime "repo_pushed_at"
    t.boolean "has_issues"
    t.boolean "has_wiki"
    t.boolean "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "primary_language"
    t.string "license"
    t.string "default_branch"
    t.boolean "is_fork"
    t.boolean "is_mirror"
    t.integer "open_issues_count"
    t.integer "closed_issues_count"
    t.integer "open_pull_requests_count"
    t.integer "merged_pull_requests_count"
    t.integer "closed_pull_requests_count"
    t.datetime "average_recent_committed_at"
    t.string "code_of_conduct_url"
    t.string "code_of_conduct_name"
    t.string "topics", default: [], null: false, array: true
    t.integer "total_issues_count"
    t.integer "total_pull_requests_count"
    t.decimal "issue_closure_rate", precision: 5, scale: 2
    t.decimal "pull_request_acceptance_rate", precision: 5, scale: 2
    t.datetime "fetched_at"
    t.index ["path"], name: "index_github_repos_on_path", unique: true
  end

  create_table "projects", id: false, force: :cascade do |t|
    t.string "permalink", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rubygem_name"
    t.citext "github_repo_path"
    t.decimal "score", precision: 5, scale: 2
    t.text "description"
    t.tsvector "permalink_tsvector"
    t.tsvector "description_tsvector"
    t.string "bugfix_fork_of"
    t.string "bugfix_fork_criteria", default: [], null: false, array: true
    t.boolean "is_bugfix_fork", default: false, null: false
    t.index ["bugfix_fork_of"], name: "index_projects_on_bugfix_fork_of"
    t.index ["description_tsvector"], name: "index_projects_on_description_tsvector", using: :gin
    t.index ["is_bugfix_fork"], name: "index_projects_on_is_bugfix_fork"
    t.index ["permalink"], name: "index_projects_on_permalink", unique: true
    t.index ["permalink_tsvector"], name: "index_projects_on_permalink_tsvector", using: :gin
    t.index ["rubygem_name"], name: "index_projects_on_rubygem_name", unique: true
    t.check_constraint "(rubygem_name IS NULL) OR ((rubygem_name)::text = (permalink)::text)", name: "check_project_permalink_and_rubygem_name_parity"
  end

  create_table "rubygem_download_stats", force: :cascade do |t|
    t.string "rubygem_name", null: false
    t.date "date", null: false
    t.integer "total_downloads", null: false
    t.integer "absolute_change_month"
    t.decimal "relative_change_month"
    t.decimal "growth_change_month"
    t.index ["absolute_change_month"], name: "index_rubygem_download_stats_on_absolute_change_month", order: "DESC NULLS LAST"
    t.index ["date"], name: "index_rubygem_download_stats_on_date"
    t.index ["growth_change_month"], name: "index_rubygem_download_stats_on_growth_change_month", order: "DESC NULLS LAST"
    t.index ["relative_change_month"], name: "index_rubygem_download_stats_on_relative_change_month", order: "DESC NULLS LAST"
    t.index ["rubygem_name", "date"], name: "index_rubygem_download_stats_on_rubygem_name_and_date", unique: true
    t.index ["total_downloads"], name: "index_rubygem_download_stats_on_total_downloads", order: "DESC NULLS LAST"
  end

  create_table "rubygem_trends", force: :cascade do |t|
    t.date "date", null: false
    t.string "rubygem_name", null: false
    t.integer "position", null: false
    t.integer "rubygem_download_stat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "position"], name: "index_rubygem_trends_on_date_and_position", unique: true
    t.index ["date"], name: "index_rubygem_trends_on_date"
    t.index ["position"], name: "index_rubygem_trends_on_position"
  end

  create_table "rubygems", id: false, force: :cascade do |t|
    t.string "name", null: false
    t.integer "downloads", null: false
    t.string "current_version", null: false
    t.string "authors"
    t.text "description"
    t.string "licenses", default: [], array: true
    t.string "bug_tracker_url"
    t.string "changelog_url"
    t.string "documentation_url"
    t.string "homepage_url"
    t.string "mailing_list_url"
    t.string "source_code_url"
    t.string "wiki_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "first_release_on"
    t.date "latest_release_on"
    t.integer "releases_count"
    t.integer "reverse_dependencies_count"
    t.datetime "fetched_at"
    t.jsonb "quarterly_release_counts", default: {}, null: false
    t.index ["name"], name: "index_rubygems_on_name", unique: true
  end

  add_foreign_key "categories", "category_groups", column: "category_group_permalink", primary_key: "permalink"
  add_foreign_key "categorizations", "categories", column: "category_permalink", primary_key: "permalink"
  add_foreign_key "categorizations", "projects", column: "project_permalink", primary_key: "permalink"
  add_foreign_key "projects", "rubygems", column: "rubygem_name", primary_key: "name"
  add_foreign_key "rubygem_download_stats", "rubygems", column: "rubygem_name", primary_key: "name"
  add_foreign_key "rubygem_trends", "rubygem_download_stats"
  add_foreign_key "rubygem_trends", "rubygems", column: "rubygem_name", primary_key: "name"
  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.categories_update_description_tsvector_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    new.description_tsvector := to_tsvector('pg_catalog.simple', coalesce(new.description, ''));
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER categories_update_description_tsvector_trigger BEFORE INSERT OR UPDATE ON \"categories\" FOR EACH ROW EXECUTE PROCEDURE categories_update_description_tsvector_trigger()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.categories_update_name_tsvector_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    new.name_tsvector := to_tsvector('pg_catalog.simple', coalesce(new.name, ''));
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER categories_update_name_tsvector_trigger BEFORE INSERT OR UPDATE ON \"categories\" FOR EACH ROW EXECUTE PROCEDURE categories_update_name_tsvector_trigger()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.projects_update_description_tsvector_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    new.description_tsvector := to_tsvector('pg_catalog.simple', coalesce(new.description, ''));
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER projects_update_description_tsvector_trigger BEFORE INSERT OR UPDATE ON \"projects\" FOR EACH ROW EXECUTE PROCEDURE projects_update_description_tsvector_trigger()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.projects_update_permalink_tsvector_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    new.permalink_tsvector := to_tsvector('pg_catalog.simple', coalesce(new.permalink, ''));
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER projects_update_permalink_tsvector_trigger BEFORE INSERT OR UPDATE ON \"projects\" FOR EACH ROW EXECUTE PROCEDURE projects_update_permalink_tsvector_trigger()")

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute(<<-SQL)
CREATE OR REPLACE FUNCTION public.rubygem_stats_calculation_month()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    previous_downloads int;
    previous_relative_change decimal;
BEGIN
    SELECT total_downloads, relative_change_month INTO previous_downloads, previous_relative_change FROM rubygem_download_stats WHERE rubygem_name = NEW.rubygem_name AND date = NEW.date - 28; IF previous_downloads IS NOT NULL THEN NEW.absolute_change_month := NEW.total_downloads - previous_downloads; IF previous_downloads > 0 THEN NEW.relative_change_month := ROUND((NEW.absolute_change_month * 100.0) / previous_downloads, 2); IF previous_relative_change IS NOT NULL THEN NEW.growth_change_month := NEW.relative_change_month - previous_relative_change; END IF; END IF; END IF;
    RETURN NEW;
END;
$function$
  SQL

  # no candidate create_trigger statement could be found, creating an adapter-specific one
  execute("CREATE TRIGGER rubygem_stats_calculation_month BEFORE INSERT OR UPDATE ON \"rubygem_download_stats\" FOR EACH ROW EXECUTE PROCEDURE rubygem_stats_calculation_month()")

end
