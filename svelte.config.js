import adapterStatic from '@sveltejs/adapter-static'
import adapterNode from '@sveltejs/adapter-node';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: vitePreprocess(),
	kit: { 
		adapter: adapterStatic(),
		adapter: process.env.PUBLIC_ADAPTER === "static"
			? adapterStatic({strict: false})
			: adapterNode(),
		paths: {
			base: "/topologia/bicocalculator",
			relative: false
		}
	}
};

export default config;
