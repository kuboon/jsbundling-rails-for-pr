require 'json'

apply "#{__dir__}/../install.rb"

if Rails.root.join("Procfile.dev").exist?
  append_to_file "Procfile.dev", "js: deno task build --watch\n"
else
  say "Add default Procfile.dev"
  copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"

  say "Ensure foreman is installed"
  run "gem install foreman"
end

say "Add default deno.config.ts"
copy_file "#{__dir__}/deno.config.ts", "deno.config.ts"

say "Add build task to deno.json"
deno_json_path = Rails.root.join("deno.json")
deno_json = deno_json_path.exist? ? JSON.parse(File.read(deno_json_path)) : {}
deno_json["tasks"] ||= {}
deno_json["tasks"]["build"] = "deno run --allow-env --allow-read --allow-write --allow-net deno.config.ts"
File.write("deno.json", JSON.pretty_generate(deno_json) + "\n")
