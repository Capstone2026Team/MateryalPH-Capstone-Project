import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync, rmSync, unlinkSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";

const generator = join(
  process.cwd(),
  "node_modules",
  "@openapitools",
  "openapi-generator-cli",
  "main.js",
);
const generations = [
  [
    "generate",
    "-i", "openapi.yaml",
    "-g", "typescript-fetch",
    "-o", "generated/typescript",
    "--additional-properties", "npmName=@materyalph/api-client-ts",
    "--additional-properties", "supportsES6=true",
    "--additional-properties", "typescriptThreePlus=true",
  ],
  [
    "generate",
    "-i", "openapi.yaml",
    "-g", "dart-dio",
    "-o", "generated/dart",
    "--additional-properties", "pubName=materyalph_api_client",
    "--additional-properties", "pubVersion=1.0.0",
  ],
];
const repositoryOwnedDartTests = new Set([
  "test/vendor_onboarding_deserialization_test.dart",
]);

for (const args of generations) {
  const outputFlag = args.indexOf("-o");
  const output = resolve(process.cwd(), args[outputFlag + 1]);
  const generatedRoot = resolve(process.cwd(), "generated");
  if (output !== generatedRoot && !output.startsWith(`${generatedRoot}\\`) && !output.startsWith(`${generatedRoot}/`)) {
    throw new Error(`Refusing to manage an output outside ${generatedRoot}`);
  }
  const manifest = join(output, ".openapi-generator", "FILES");
  const previousFiles = existsSync(manifest)
    ? new Set(readFileSync(manifest, "utf8").split(/\r?\n/u).filter(Boolean))
    : new Set();

  // Generator test scaffolds are skipped when they already exist, which makes
  // its FILES manifest depend on the previous run. Regenerate them consistently.
  const testDirectory = join(output, "test");
  if (existsSync(testDirectory)) {
    for (const entry of readdirSync(testDirectory)) {
      if (entry.endsWith(".dart") && !repositoryOwnedDartTests.has(`test/${entry}`)) {
        unlinkSync(join(testDirectory, entry));
      }
    }
  }

  const result = spawnSync(process.execPath, [generator, ...args], {
    cwd: process.cwd(),
    stdio: "inherit",
  });

  if (result.error) {
    throw result.error;
  }

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }

  const currentFiles = existsSync(manifest)
    ? new Set(readFileSync(manifest, "utf8").split(/\r?\n/u).filter(Boolean))
    : new Set();
  if (existsSync(join(output, ".openapi-generator-ignore"))) {
    currentFiles.add(".openapi-generator-ignore");
  }
  for (const relativePath of repositoryOwnedDartTests) {
    if (existsSync(join(output, relativePath))) currentFiles.add(relativePath);
  }
  writeFileSync(manifest, `${[...currentFiles].sort().join("\n")}\n`);
  // Normalize generator-owned text at the source of generation, never by hand.
  for (const relativePath of currentFiles) {
    if (!/\.(md|ts|dart|json|yaml|yml)$/u.test(relativePath)) continue;
    const generatedPath = resolve(output, relativePath);
    if (!generatedPath.startsWith(`${output}\\`) && !generatedPath.startsWith(`${output}/`)) {
      throw new Error("Generated manifest contains a path outside its output directory");
    }
    if (!existsSync(generatedPath)) continue;
    let contents = readFileSync(generatedPath, "utf8");
    if (relativePath.endsWith(".dart") && relativePath.startsWith("lib/")) {
      // dart-dio emits imports for error responses and flattened allOf models
      // even when its generated implementation never references those types.
      const body = contents.replace(/^import .*;\r?\n/gmu, "");
      contents = contents.replace(/^import '([^']+)';\r?\n/gmu, (line, uri) => {
        let symbol;
        if (uri === "package:built_value/json_object.dart") symbol = "JsonObject";
        if (uri.startsWith("package:materyalph_api_client/src/model/")) {
          const importedPath = join(output, "lib", uri.slice("package:materyalph_api_client/".length));
          if (existsSync(importedPath)) symbol = readFileSync(importedPath, "utf8").match(/\bclass\s+(\w+)/u)?.[1];
        }
        return symbol && !new RegExp(`\\b${symbol}\\b`, "u").test(body) ? "" : line;
      });
    }
    writeFileSync(generatedPath, contents.replace(/[\t ]+$/gmu, ""));
  }
  for (const relativePath of previousFiles) {
    if (currentFiles.has(relativePath)) continue;
    const stalePath = resolve(output, relativePath);
    if (stalePath.startsWith(`${output}\\`) || stalePath.startsWith(`${output}/`)) {
      if (existsSync(stalePath)) unlinkSync(stalePath);
    }
  }

  const dartModelDirectory = join(output, "lib", "src", "model");
  if (existsSync(dartModelDirectory)) {
    for (const entry of readdirSync(dartModelDirectory)) {
      if (!entry.endsWith(".g.dart")) continue;
      const source = join(dartModelDirectory, entry.replace(/\.g\.dart$/u, ".dart"));
      if (!existsSync(source)) unlinkSync(join(dartModelDirectory, entry));
    }
  }

  const dartTestDirectory = join(output, "test");
  if (existsSync(dartTestDirectory)) {
    for (const entry of readdirSync(dartTestDirectory)) {
      const relativePath = `test/${entry}`;
      if (entry.endsWith(".dart") && !currentFiles.has(relativePath)) {
        unlinkSync(join(dartTestDirectory, entry));
      }
    }
  }

  const legacyGeneratorBackup = join(output, ".openapi-generator", "lib");
  if (existsSync(legacyGeneratorBackup)) {
    rmSync(legacyGeneratorBackup, { recursive: true, force: true });
  }
}
