import { spawnSync } from 'child_process';
import * as fs from 'node:fs';
import { Translation } from './translation/translation.js';
import { readFileSync, watchFile } from 'fs';
import { traceWriter, TraceWriter } from './TraceWriter.js';
import { RenderWidget } from './ast.js';
import * as yaml from 'js-yaml';
export default class JGen {
    async #_getTargetConfig(app) {
        traceWriter.info("Getting target from config targets.json file", TraceWriter.AREA_GENERAL);
        let targets = JSON.parse(readFileSync('./targets.json', 'utf-8'));
        return Promise.resolve(targets.targets[app?.app?.target]);
    }
    async start(command, appfile, watch = false) {
        console.log("watch", watch);
        if (watch) {
            watchFile(appfile, async () => {
                traceWriter.info("Starting a new run", TraceWriter.AREA_GENERAL);
                let app = appfile.endsWith(".yml") ? yaml.load(readFileSync(appfile, 'utf-8')) : JSON.parse(readFileSync(appfile, 'utf-8'));
                console.log("compiling file");
                let target = await this.#_getTargetConfig(app);
                await this.compile(target, app);
                console.log("done");
            });
        }
        traceWriter.info("Starting a new run", TraceWriter.AREA_GENERAL);
        let app = appfile.endsWith(".yml") ? yaml.load(readFileSync(appfile, 'utf-8')) : JSON.parse(readFileSync(appfile, 'utf-8'));
        await this._start(command, app, watch);
    }
    async _start(command, app, watch = false) {
        traceWriter.info("Starting a new run", TraceWriter.AREA_GENERAL);
        console.log("compiling file");
        let target = await this.#_getTargetConfig(app);
        await this.compile(target, app);
        if (command == "run") {
            console.log("starting runner" + `./build/${watch ? 'watchers/' + target.watcher : 'runners/' + target.runner}`);
            traceWriter.info("Starting runner", TraceWriter.AREA_GENERAL);
            spawnSync('node', [`./build/${watch ? 'watchers/' + target.watcher : 'runners/' + target.runner}`], { stdio: [process.stdin, process.stdout, process.stderr], });
            console.log("done starting runner" + `./build/${watch ? 'watchers/' + target.watcher : 'runners/' + target.runner}`);
        }
        console.log("done");
    }
    async compile(target, app) {
        traceWriter.info("Starting generation", TraceWriter.AREA_GENERAL);
        if (!target) {
            traceWriter.error("Error: - no valid target specified -", TraceWriter.AREA_GENERAL);
            return;
        }
        traceWriter.info("Translation found, generating code for output", TraceWriter.AREA_GENERAL);
        fs.writeFileSync(target.output, await this.#_generate(target, app, new Translation(target.translationmap)));
        traceWriter.info("Code generation completed, writing output to " + target.output, TraceWriter.AREA_GENERAL);
    }
    async #_generate(target, app, translation) {
        traceWriter.info("Starting generation", TraceWriter.AREA_CODEGENERATION);
        return await this.#_generateCode(target, await this.#_loadComponents(app), translation);
    }
    async #_loadComponents(app) {
        traceWriter.info("Loading component tree", TraceWriter.AREA_CODEGENERATION);
        let tree = RenderWidget.fromObject(app);
        traceWriter.info("Loaded component tree " + JSON.stringify(tree), TraceWriter.AREA_CODEGENERATION);
        return Promise.resolve(tree);
    }
    async #_generateCode(target, tree, translation) {
        traceWriter.info("Starting code generation", TraceWriter.AREA_CODEGENERATION);
        let code = await RenderWidget.render(target, tree, translation) || "";
        traceWriter.info("Code generation complete " + code, TraceWriter.AREA_CODEGENERATION);
        console.log("code", code);
        return code;
    }
}
//# sourceMappingURL=index.js.map