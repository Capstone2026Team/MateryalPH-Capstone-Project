# Shared configuration

`tsconfig.react.json` is the strict TypeScript baseline for both React portals and future shared React packages.

`vite-api-client.mjs` watches the linked generated API client's output for both portals. Each portal prebundles that client and refreshes the optimizer once generation finishes.
