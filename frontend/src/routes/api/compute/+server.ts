import { json, error } from '@sveltejs/kit';
import type { RequestEvent, RequestHandler } from './$types';
import { spawn } from "child_process";

let runBico = (input: string) => {
    return new Promise(function(success, nosuccess) {
        // const { spawn } = require("child_process");
        const pyprog = spawn("sage", ["--python", "src/routes/api/compute/bico.py", input]);

        pyprog.stdout.on("data", (data) => {
            success(data);
        });
        pyprog.stderr.on("data", (data) => {
            nosuccess(data);
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
