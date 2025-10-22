import adapterStatic from '@sveltejs/adapter-static'
import adapterNode from '@sveltejs/adapter-node';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://svelte.dev/docs/kit/integrations
	// for more information about preprocessors
	preprocess: vitePreprocess(),
	kit: { 
		adapter: adapterStatic(),
		adapter: process.env.PUBLIC_ADAPTER === "static"
			? adapterStatic()
			: adapterNode(),
		paths: {
			base: "/topologia/bbcalculator",
			relative: false
		}
	}
};

export default config;
