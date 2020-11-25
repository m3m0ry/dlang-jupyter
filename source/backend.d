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
        immutable lines = code.splitLines.array;
        auto result = textResult("Incomplete code: " ~ code);
        int begin = 0;
        int end = 1;
        for(; end <= lines.length; ++end)
        {
            auto part = lines[begin..end].join("/n");
            if (intp.classify(part) != intp.Kind.Incomplete)
            {
                begin = end;
                auto res = intp.interpret(part);
                final switch (res.state) with (InterpreterResult.State)
                {
                case success:
                    result = textResult(res.stdout ~ "\n" ~ res.stderr);
                    break;
                case incomplete:
                    return textResult("Incomplete code: " ~ part);
                case error:
                    return textResult(res.stdout ~ "\n" ~ res.stderr);
                }
            }
        }
        return result;
    }

    CompleteResult complete(string code, long cursorPos)
    {
        import std.algorithm : map, canFind;
        import std.array : array;

        CompleteResult ret;
        return ret;
    }
}