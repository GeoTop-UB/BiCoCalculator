import adapterStatic from '@sveltejs/adapter-static'
import adapterNode from '@sveltejs/adapter-node';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

const buildDir = "_build";

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: vitePreprocess(),
	kit: { 
		adapter: process.env.PUBLIC_ADAPTER === "node"
			? adapterNode({ out: buildDir })
			: adapterStatic({ pages: buildDir, strict: false }),
		paths: {
			base: "/topologia/bicocalculator",
			relative: false
		}
	}
};

export default config;
