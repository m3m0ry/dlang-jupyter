import std.exception : enforce;

import drepl : interpreter, dmdEngine;
import jupyter.wire.kernel : kernel;
import jupyter.wire.log : log;

import backend : DreplBackend;


int main(string[] args)
{
    const exeName = args.length > 0 ? args[0] : "<exeName>";
    enforce(args.length == 2, "Usage: " ~ exeName ~ " <connectionFileName>");
    const connectionFileName = args[1];

    try
    {
        auto intp = interpreter(dmdEngine());
        DreplBackend backend = DreplBackend(&intp);
        auto k = kernel(backend, connectionFileName);
        k.run();
        return 0;
    }
    catch (Exception e)
    {
        log("Error: ", e.msg);
        return 1;
    }
    catch (Error e)
    {
        log("FATAL ERROR: ", e.toString);
        return 2;
    }
}
