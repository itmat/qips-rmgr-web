# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{qips-rmgr-web}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Austin", "Andrew Brader"]
  s.date = %q{2010-01-13}
  s.description = %q{Works with qips node to manage aws instances based on demand.}
  s.email = %q{daustin@mail.med.upenn.edu}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "VERSION",
     "app/controllers/application_controller.rb",
     "app/controllers/farms_controller.rb",
     "app/controllers/instances_controller.rb",
     "app/controllers/recipes_controller.rb",
     "app/controllers/roles_controller.rb",
     "app/helpers/application_helper.rb",
     "app/helpers/farms_helper.rb",
     "app/helpers/instances_helper.rb",
     "app/helpers/recipes_helper.rb",
     "app/helpers/roles_helper.rb",
     "app/models/event_log.rb",
     "app/models/farm.rb",
     "app/models/instance.rb",
     "app/models/recipe.rb",
     "app/models/role.rb",
     "app/views/farms/_form.html.erb",
     "app/views/farms/edit.html.erb",
     "app/views/farms/index.html.erb",
     "app/views/farms/new.html.erb",
     "app/views/farms/reconcile.html.erb",
     "app/views/farms/reconcile_all.html.erb",
     "app/views/farms/show.html.erb",
     "app/views/instances/index.html.erb",
     "app/views/instances/set_status.html.erb",
     "app/views/layouts/application.html.erb",
     "app/views/recipes/edit.html.erb",
     "app/views/recipes/index.html.erb",
     "app/views/recipes/new.html.erb",
     "app/views/recipes/show.html.erb",
     "app/views/roles/_form.html.erb",
     "app/views/roles/edit.html.erb",
     "app/views/roles/index.html.erb",
     "app/views/roles/new.html.erb",
     "app/views/shared/_heading.html.erb",
     "config/boot.rb",
     "config/database.yml",
     "config/environment.rb",
     "config/environments/cucumber.rb",
     "config/environments/development.rb",
     "config/environments/production.rb",
     "config/environments/test.rb",
     "config/initializers/backtrace_silencers.rb",
     "config/initializers/inflections.rb",
     "config/initializers/mime_types.rb",
     "config/initializers/new_rails_defaults.rb",
     "config/initializers/session_store.rb",
     "config/iptables.erb",
     "config/locales/en.yml",
     "config/routes.rb",
     "db/migrate/20090929180916_create_farms.rb",
     "db/migrate/20090929181104_create_roles.rb",
     "db/migrate/20090929181338_create_instances.rb",
     "db/migrate/20090929184112_create_users.rb",
     "db/migrate/20090930194449_drop_users.rb",
     "db/migrate/20091001175642_create_recipes.rb",
     "db/migrate/20091002174617_create_recipes_roles.rb",
     "db/migrate/20091002205651_add_key_groups_to_farm.rb",
     "db/migrate/20091006145900_add_launch_time_to_instance.rb",
     "db/migrate/20091007195444_remove_recipes_from_role.rb",
     "db/migrate/20091008182853_add_farm_type_to_farms.rb",
     "db/migrate/20091008183318_add_prov_buffer_launch_buffer_to_roles.rb",
     "db/migrate/20091008183453_add_prov_time_to_instances.rb",
     "db/migrate/20091008184049_remove_enabled_from_farms.rb",
     "db/migrate/20091009190223_create_delayed_jobs.rb",
     "db/migrate/20091118204118_remove_prov_time_from_instance.rb",
     "db/migrate/20091118205845_add_state_changed_at_executable_ruby_pid_status_updated_at_to_instance.rb",
     "db/migrate/20091119201845_remove_cpu_top_from_instance.rb",
     "db/migrate/20091119202221_add_ruby_cpu_usage_system_cpu_usage_ruby_mem_usage_system_mem_usage_to_instance.rb",
     "db/migrate/20091119202408_add_top_pid_ruby_pid_status_to_instance.rb",
     "db/migrate/20091120185805_add_cycle_count_to_instance.rb",
     "db/migrate/20091130190402_add_ruby_cycle_count_to_instance.rb",
     "db/migrate/20091204204140_remove_prov_buffer_launch_buffer_from_role.rb",
     "db/migrate/20091204211042_add_kernel_id_to_farm.rb",
     "db/migrate/20091204211325_add_public_dns_name_to_instance.rb",
     "db/migrate/20091207174511_rename_key_groups_in_farm.rb",
     "db/migrate/20100107173252_create_event_logs.rb",
     "db/migrate/20100108202518_add_child_procs_to_instance.rb",
     "db/migrate/20100113170742_add_user_data_to_farm.rb",
     "db/migrate/20100113172653_remove_user_data_from_farm.rb",
     "db/migrate/20100113172711_add_default_user_data_to_farm.rb",
     "db/migrate/20100113174830_add_user_data_to_instance.rb",
     "db/seeds.rb",
     "doc/README_FOR_APP",
     "features/manage_farm.feature",
     "features/manage_instances.feature",
     "features/manage_recipes.feature",
     "features/manage_roles.feature",
     "features/step_definitions/helper_steps.rb",
     "features/step_definitions/model_steps.rb",
     "features/step_definitions/user_steps.rb",
     "features/step_definitions/webrat_steps.rb",
     "features/support/env.rb",
     "features/support/factories.rb",
     "features/support/paths.rb",
     "lib/instance_monitor.rb",
     "lib/ip_access_writer.rb",
     "lib/tasks/cucumber.rake",
     "lib/tasks/rspec.rake",
     "lib/work_item_helper.rb",
     "public/404.html",
     "public/422.html",
     "public/500.html",
     "public/favicon.ico",
     "public/images/green_atoms.jpg",
     "public/images/qips.png",
     "public/images/rails.png",
     "public/javascripts/application.js",
     "public/javascripts/controls.js",
     "public/javascripts/dragdrop.js",
     "public/javascripts/effects.js",
     "public/javascripts/prototype.js",
     "public/robots.txt",
     "public/stylesheets/application.css",
     "public/stylesheets/scaffold.css",
     "script/about",
     "script/autospec",
     "script/console",
     "script/cucumber",
     "script/dbconsole",
     "script/delayed_job",
     "script/destroy",
     "script/generate",
     "script/performance/benchmarker",
     "script/performance/profiler",
     "script/plugin",
     "script/runner",
     "script/server",
     "script/spec",
     "script/spec_server",
     "spec/controllers/farms_controller_spec.rb",
     "spec/controllers/instances_controller_spec.rb",
     "spec/factories.rb",
     "spec/fixtures/farms.yml",
     "spec/fixtures/instances.yml",
     "spec/fixtures/roles.yml",
     "spec/helpers/farms_helper_spec.rb",
     "spec/helpers/instances_helper_spec.rb",
     "spec/integration/farms_spec.rb",
     "spec/integration/instances_spec.rb",
     "spec/models/farm_spec.rb",
     "spec/models/instance_spec.rb",
     "spec/rcov.opts",
     "spec/routing/farms_routing_spec.rb",
     "spec/routing/instances_routing_spec.rb",
     "spec/routing/roles_routing_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "vendor/plugins/delayed_job/MIT-LICENSE",
     "vendor/plugins/delayed_job/README.textile",
     "vendor/plugins/delayed_job/Rakefile",
     "vendor/plugins/delayed_job/VERSION",
     "vendor/plugins/delayed_job/contrib/delayed_job.monitrc",
     "vendor/plugins/delayed_job/delayed_job.gemspec",
     "vendor/plugins/delayed_job/generators/delayed_job/delayed_job_generator.rb",
     "vendor/plugins/delayed_job/generators/delayed_job/templates/migration.rb",
     "vendor/plugins/delayed_job/generators/delayed_job/templates/script",
     "vendor/plugins/delayed_job/init.rb",
     "vendor/plugins/delayed_job/lib/delayed/command.rb",
     "vendor/plugins/delayed_job/lib/delayed/job.rb",
     "vendor/plugins/delayed_job/lib/delayed/message_sending.rb",
     "vendor/plugins/delayed_job/lib/delayed/performable_method.rb",
     "vendor/plugins/delayed_job/lib/delayed/recipes.rb",
     "vendor/plugins/delayed_job/lib/delayed/tasks.rb",
     "vendor/plugins/delayed_job/lib/delayed/worker.rb",
     "vendor/plugins/delayed_job/lib/delayed_job.rb",
     "vendor/plugins/delayed_job/recipes/delayed_job.rb",
     "vendor/plugins/delayed_job/spec/database.rb",
     "vendor/plugins/delayed_job/spec/delayed_method_spec.rb",
     "vendor/plugins/delayed_job/spec/job_spec.rb",
     "vendor/plugins/delayed_job/spec/story_spec.rb",
     "vendor/plugins/delayed_job/tasks/jobs.rake"
  ]
  s.homepage = %q{http://github.com/abrader/qips-rmgr-web}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Web-based resource manager for QIPS suite.}
  s.test_files = [
    "spec/controllers/farms_controller_spec.rb",
     "spec/controllers/instances_controller_spec.rb",
     "spec/factories.rb",
     "spec/helpers/farms_helper_spec.rb",
     "spec/helpers/instances_helper_spec.rb",
     "spec/integration/farms_spec.rb",
     "spec/integration/instances_spec.rb",
     "spec/models/farm_spec.rb",
     "spec/models/instance_spec.rb",
     "spec/routing/farms_routing_spec.rb",
     "spec/routing/instances_routing_spec.rb",
     "spec/routing/roles_routing_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
