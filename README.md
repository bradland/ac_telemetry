# AC Telemetry - An Assetto Corsa Telemetry Logger

## This project is WIP

I'm still in the very early stages of building this tool, so expect the code to change... significantly. If you'd like to contribute, I'd be happy to have you! Github's fork and pull request features are my preferred method of collaboration.

## What is it?

AC Telemetry is a telemetry logger for the Kunos' racing simulator, Assetto Corsa. Assetto Corsa (AC) provides a UDP interface for receiving telemetry updates for active race sessions. This software connects to the AC UDP Telemetry Server and subscribes to updates.

This is a CLI tool! CLI stands for command line interface. If you're not already familiar with the command prompt, you should get comfortable with one of two things:

1) There is much you'll have to learn about how to use a terminal, which I'm not going to cover here, and won't address in any Github issues submitted. Sorry!

2) You might be better off waiting for someone to release a GUI telemetry logger that works with the AC UDP Telemetry API.

## What is it for?

A telemetry logger allows you to capture data like vehicle speed, engine RPM, g-forces on three different axes, wheel slip angle, track position, lap timing, etc. Logging this data allows you to analyze car _and_ driver performance.

## This looks like a mess

Hey, I'm just a hobbyist! This code is very much a work-in-progress. Eventually, it will be distributed as a Gem. Right now, I'm still working out the structure of the application, including how it will work.

I still have many things to figure out, like how I'll handle different types of updates from AC (car info vs lap info vs handshakes), how configuration will be passed to the tool (what fields to log, specifying conditionals, etc).

## I'd kind of like to try it anyway

Whatever documentation I come up with will be in the [Wiki](https://github.com/bradland/ac_telemetry/wiki). Good luck and godspeed!