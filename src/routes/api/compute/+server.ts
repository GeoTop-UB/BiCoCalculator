import { json, error } from '@sveltejs/kit';
import type { RequestEvent, RequestHandler } from './$types';
import { spawn } from "child_process";
import { SERVER_BICO_PATH } from "$env/static/private";

let runBico = (input: string) => {
    return new Promise((resolve, reject) => {
        const pyprog = spawn("sage", [
            "--python", 
            "src/routes/api/compute/bico.py", 
            SERVER_BICO_PATH, 
            input
        ]);

        pyprog.stdout.on("data", (data) => {
            resolve(data);
        });
        pyprog.stderr.on("data", (data) => {
            reject(data);
        });
    });
}

export const POST: RequestHandler = async ({ request } : RequestEvent) => {
    const input = await request.json();
    console.log(input)
    let bico = runBico(JSON.stringify(input));
    return await bico.then(output => {
        console.log(output.toString());
	    return json(JSON.parse(output.toString()))
    }).catch(err => {
        console.log(err.toString());
        return error(404);
    });
}
