# eutaxy-core [WIP]

**exy-core is a resource created for making development easier on FiveM.**

Using this script, you'll be able to write code that's actually maintainable and secure.

## 📚 Setup

**Standalone**

- Download [the latest release](https://github.com/eutaxy/core/releases/latest) and extract it inside `server-data/resources/exy_core`.
- Add `@exy_core/CompatLayer.lua` to every resource, you want to use this core.

**With eutaxy-workspace (for experienced developers, includes preprocessing and few other cool features 😎)**

```sh
git clone https://github.com/eutaxy/workspace eutaxy-workspace
cd eutaxy-workspace/src/
git clone https://github.com/eutaxy/core exy_core
cd ..
yarn run update
yarn run dev
```

That's it. Have fun :D
