import std.conv;
import std.stdio;

import std.exception : enforce;

import drepl;
import jupyter.wire.kernel;
import jupyter.wire.message : CompleteResult;
import jupyter.wire.log : log;

class DreplException : Exception
{
    import std.exception : basicExceptionCtors;

    mixin basicExceptionCtors;
}

struct DreplBackend
{

    auto languageInfo = LanguageInfo("dlang", "2.92", ".d");
    Interpreter!DMDEngine* intp;

    this(Interpreter!DMDEngine* i)
    {
        intp = i;
    }

    //ExecutionResult execute(in string code, scope IoPubMessageSender sender) @trusted
    ExecutionResult execute(in string code) @trusted
    {
        import std.conv : text;

        auto res = intp.interpret(code);
        writeln(res.stdout);
        writeln(res.stderr);
        final switch (res.state) with (InterpreterResult.State)
        {
        case incomplete:
            throw new DreplException("Incomplete code");
        case success:
            return textResult(res.stdout);
        case error:
            throw new DreplException(res.stderr);
        }
    }

    CompleteResult complete(string code, long cursorPos)
    {
        import std.algorithm : map, canFind;
        import std.array : array;

        CompleteResult ret;
        return ret;
    }
}

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
