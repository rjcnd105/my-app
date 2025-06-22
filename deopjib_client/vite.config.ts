import { defineConfig } from "vite";
import tsConfigPaths from "vite-tsconfig-paths";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import tailwindcss from "@tailwindcss/vite";
import { iconsSpritesheet } from "vite-plugin-icons-spritesheet";
import { iconSpriteDir, iconSpriteFilename } from "./src/constants/dev";

export default defineConfig({
  plugins: [
    tailwindcss(),
    tsConfigPaths({
      projects: ["./tsconfig.json"],
    }),
    tanstackStart({
      tsr: {
        routesDirectory: "src/routes", // Defaults to "src/routes"
      },
    }),
    iconsSpritesheet({
      // Defaults to false, should it generate TS types for you
      withTypes: true,
      // The path to the icon directory
      inputDir: "./src/icons",

      // Output path for the generated spritesheet and types
      outputDir: `./public${iconSpriteDir}`,
      // Output path for the generated type file, defaults to types.ts in outputDir
      typesOutputFile: "./src/icons/types.gen.ts",
      // The name of the generated spritesheet, defaults to sprite.svg
      fileName: iconSpriteFilename,
      // The cwd, defaults to process.cwd()
      cwd: process.cwd(),
      // What formatter to use to format the generated files, prettier or biome, defaults to no formatter
      formatter: "biome",
      // Callback function that is called when the script is generating the icon name
      // This is useful if you want to modify the icon name before it is written to the file
      iconNameTransformer: (iconName) => iconName,
    }),
  ],
});
