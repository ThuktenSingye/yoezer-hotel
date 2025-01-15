import globals from "globals";
import pluginJs from "@eslint/js";

/** @type {import('eslint').Linter.Config[]} */
export default [
  {
    languageOptions: {
      globals: globals.browser,
      parserOptions: {
        ecmaVersion: 2021,
        sourceType: "module",
      },
    },
    rules: {
      // Best Practices
      "eqeqeq": ["error", "always"],
      "curly": "error",
      "no-console": "warn",
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "prefer-const": "error",

      // Stylistic Choices
      "semi": ["error", "always"],
      "quotes": ["error", "single"],
      "indent": ["error", 2],

      // Additional Rules
      "no-magic-numbers": ["warn", { ignore: [0, 1] }],
      "consistent-return": "error",

    },
  },
  pluginJs.configs.recommended,
];
