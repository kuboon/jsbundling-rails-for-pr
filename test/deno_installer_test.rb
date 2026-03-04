require "test_helper"
require_relative "shared_installer_tests"

class DenoInstallerTest < ActiveSupport::TestCase
  include RailsAppHelpers
  include SharedInstallerTests

  test "deno installer with pre-existing files" do
    with_new_rails_app do
      File.write("Procfile.dev", "pre: existing\n", mode: "a+")

      run_installer

      File.read("Procfile.dev").tap do |procfile|
        assert_match "pre: existing", procfile
        assert_match "js: deno task build --watch", procfile
      end

      JSON.parse(File.read("deno.json")).tap do |deno_json|
        assert_equal "deno run --allow-env --allow-read --allow-write --allow-net deno.config.ts", deno_json["tasks"]["build"]
      end
    end
  end

  test "deno installer without pre-existing files" do
    with_new_rails_app do
      FileUtils.rm_rf("Procfile.dev")

      out, _err = run_installer

      File.read("Procfile.dev").tap do |procfile|
        assert_match "js: deno task build --watch", procfile
      end

      assert_match "STUBBED gem install foreman", out
    end
  end

  private
    def run_installer
      stub_bins("gem")
      run_command("bin/rails", "javascript:install:deno")
    end
end
