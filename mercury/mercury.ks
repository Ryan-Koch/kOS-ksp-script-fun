// mercury scripts

// clear screen
clearScreen.

// lock the throttle to 100%
lock throttle to 1.0.

// countdown loop
countdown_timer(10, "Countdown for Mercury launch:").

// activate the stage so something happens
UNTIL ship:maxthrust > 0 {
    wait 0.5. // pause half a second between stage attempts
    print "Stage activated".
    stage.
}

// the first turn to get a good angle
when ship:airspeed > 0 then {
    print "5 seconds until first turn".
    FROM {local countdown is 5.} UNTIL countdown = 0 STEP { SET countdown to countdown - 1. } DO {
        print "..." + countdown.
        wait 1.
    }
    print "Setting heading to 90, 80".
    lock steering to heading(90, 80).
}

when ship:obt:apoapsis >= 119000 then {
    lock throttle to 0.
    print "throttle to: " + throttle.
    countdown_timer(5, "5 seconds until next stage:").
    print "staging".
    stage.
    countdown_timer(20, "20 seconds until next stage:").
    print "staging".
    stage.
    print "RCS on".
    RCS on.
    print rcs.

    when ship:verticalspeed <= 0 then {
        print "Steer to retrograde".
        lock steering to ship:retrograde.
        print "We've crossed ap. Going to next stage".
        stage.
        
        when ship:altitude <= 80000 then {
            print "We're below 80km going to next stage".
            stage.
        }
    }

}

when ship:STAGENUM = 0 and ship:airspeed <= 2 then {
    print "Mission accomplished. Congratulations!".
}

// end program
wait until ship:STAGENUM = 0 and ship:airspeed <= 1. 


function countdown_timer {
    parameter seconds.
    parameter message.

    print message:tostring.
    FROM {local countdown is seconds.} UNTIL countdown = 0 STEP { SET countdown to countdown - 1. } DO {
    print "..." + countdown.
    wait 1.
    }
}




