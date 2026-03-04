import * as esbuild from "npm:esbuild";
import { join } from "jsr:@std/path";

const config: esbuild.BuildOptions = {
  sourcemap: true,
  entryPoints: ["app/javascript/application.js"],
  outdir: join(Deno.cwd(), "app/assets/builds"),
  bundle: true,
};

if (Deno.args.includes("--watch")) {
  const ctx = await esbuild.context(config);
  await ctx.watch();
} else {
  await esbuild.build(config).catch(() => Deno.exit(1));
  esbuild.stop();
  Deno.exit(0);
}
