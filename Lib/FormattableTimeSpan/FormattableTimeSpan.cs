using System;
using System.Collections.Generic;

public class FormattableTimeSpan : IFormattable
{
    private readonly TimeSpan _timeSpan;

    public FormattableTimeSpan(TimeSpan timeSpan)
    {
        _timeSpan = timeSpan;
    }

    public string ToString(string format, IFormatProvider formatProvider)
    {
        if (string.IsNullOrEmpty(format))
        {
            format = "elapsed"; // Default to custom elapsed time format
        }

        switch (format.ToLowerInvariant())
        {
            case "c": // Standard TimeSpan format
                return _timeSpan.ToString();
            case "elapsed": // Default elapsed time format
                return ToElapsedString();
            default:
                throw new FormatException($"The format '{format}' is not supported.");
        }
    }

    public string ToString(string format) // One-parameter overload
    {
        return ToString(format, formatProvider: null); // Default formatProvider to null
    }

    public override string ToString()
    {
        return ToElapsedString(); // Default to custom elapsed time format
    }

    public string ToElapsedString()
    {
        return FormatElapsedTime(dayUnit: "d", hourUnit: "h", minuteUnit: "m", secondUnit: "s");
    }

    public string ToShortElapsedString()
    {
        return FormatElapsedTime(dayUnit: "day", hourUnit: "hr", minuteUnit: "min", secondUnit: "sec");
    }

    public string ToLongElapsedString()
    {
        return FormatElapsedTime(dayUnit: "days", hourUnit: "hours", minuteUnit: "minutes", secondUnit: "seconds");
    }

    private string FormatElapsedTime(string dayUnit, string hourUnit, string minuteUnit, string secondUnit)
    {
        List<string> components = new List<string>();

        if (_timeSpan.TotalDays >= 1)
        {
            components.Add($"{Math.Floor(_timeSpan.TotalDays)}{dayUnit}");
            components.Add($"{_timeSpan.Hours}{hourUnit}");
            components.Add($"{_timeSpan.Minutes}{minuteUnit}");
            components.Add($"{Math.Round(_timeSpan.Seconds + _timeSpan.Milliseconds / 1000.0, 2)}{secondUnit}");
        }
        else if (_timeSpan.TotalHours >= 1)
        {
            components.Add($"{Math.Floor(_timeSpan.TotalHours)}{hourUnit}");
            components.Add($"{_timeSpan.Minutes}{minuteUnit}");
            components.Add($"{Math.Round(_timeSpan.Seconds + _timeSpan.Milliseconds / 1000.0, 2)}{secondUnit}");
        }
        else if (_timeSpan.TotalMinutes >= 1)
        {
            components.Add($"{Math.Floor(_timeSpan.TotalMinutes)}{minuteUnit}");
            components.Add($"{Math.Round(_timeSpan.Seconds + _timeSpan.Milliseconds / 1000.0, 2)}{secondUnit}");
        }
        else
        {
            components.Add($"{Math.Round(_timeSpan.TotalSeconds, 2)}{secondUnit}");
        }

        return string.Join(" ", components);
    }
}
