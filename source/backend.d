module backend;

import std.string : splitLines;
import std.array : join, array;

import drepl : Interpreter, DMDEngine, InterpreterResult;
import jupyter.wire.kernel : LanguageInfo, ExecutionResult, textResult;
import jupyter.wire.message : CompleteResult;


class DreplException : Exception
{
    import std.exception : basicExceptionCtors;

    mixin basicExceptionCtors;
}

struct DreplBackend
{

    auto languageInfo = LanguageInfo("dlang", "2.94", ".d");
    Interpreter!DMDEngine* intp;

    this(Interpreter!DMDEngine* i)
    {
        intp = i;
    }

    //ExecutionResult execute(in string code, scope IoPubMessageSender sender) @trusted
    ExecutionResult execute(in string code) @trusted
    {
        immutable kind = intp.classify(code);
        switch(kind)
        {
            case intp.Kind.Incomplete:
                return textResult("Incomplete code: " ~ code);
            case intp.Kind.Error:
                return textResult("Error: " ~ code);
            default:
                auto res = intp.interpret(code);
                final switch (res.state) with (InterpreterResult.State)
                {
                case success:
                    return textResult(res.stdout ~ "\n" ~ res.stderr);
                case incomplete:
                    return textResult("Incomplete code: " ~ code);
                case error:
                    return textResult(res.stdout ~ "\n" ~ res.stderr);
                }
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