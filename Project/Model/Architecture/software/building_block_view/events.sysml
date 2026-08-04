package Events {
    enum def ButtonId {
        enum Local;
        enum Remote;
    }

    enum def EventID {
        /* Button related events.
         * Reception of Short/Long/VeryLong does not mean that button has been released.
         * It is information how long it is pressed (measured at runtime). So if the user 
         * presses the buttons for very long, all three events will be issued.
         */
        enum ButtonShortPress;
        enum ButtonLongPress;
        enum ButtonVeryLongPress;
        enum ButtonReleased;

        /* Shutters related events. */
        enum ShutterMoveUp;
        enum ShutterMoveDown;
        enum ShutterStop;

        /* UI related events. */
        enum UINotify;
    }

    item def Event {
        attribute id : EventID;
    }

    // Events definition
    item def ShortButtonPressEvent specializes Event {
        attribute redefines id = EventID::ButtonShortPress;
        attribute button : ButtonId;
    }

    item def LongButtonPressEvent specializes Event {
        attribute redefines id = EventID::ButtonLongPress;
        attribute button : ButtonId;
    }

    item def ButtonReleasedEvent specializes Event {
        attribute redefines id = EventID::ButtonReleased;
        attribute button : ButtonId;
    }

    // Shutter related events
    item def MoveShutterUpEvent specializes Event {
        attribute redefines id = EventID::ShutterMoveUp;
    }

    item def MoveShutterDownEvent specializes Event {
        attribute redefines id = EventID::ShutterMoveDown;
    }

    item def ShutterStopEvent specializes Event {
        attribute redefines id = EventID::ShutterStop;
    }

    item def UINotifyEvent specializes Event {
        attribute redefines id = EventID::UINotify;
    }

    /*
        States:
            Idle
            AnyModeCandidate;
            ConfigModeCandidate;
            AutoMode;
            ManualMode;
            ConfigMode;

        Auto-up/down
            User presses button
            ButtonShortPress is issued
            App enters AnyModeCandidate and waits for short (from other button) and long press or button release.
            User releases the button -> release button event is issued.
            App enters AutoMode -> clear automatic mode situation.
                Starts the timer
                Listenes for any button press -> exit immediatelly on reception.
                Once timer elapses, resets mode to Idle;

        Manual up/down 
            User presses button
            ButtonShortPress is issued
            App enters AnyModeCandidate and waits for short (from other button) and long press or button release.
            User still holds the button -> ButtonLongPress is issued
                If no second button is pressed -> App enters ManualMode. Turn motor UP/DOWN ON

                User releases the button -> ButtonReleased event is issued.
                Motor is turned OFF, App enters Idle;

        Configuration mode
            User presses button
            ButtonShortPress is issued
            App enters AnyModeCandidate and waits for short (from other button) and long press or button release.
            In meantime user presses second button. App enters ConfigModeCandidate;
            User still holds the button -> ButtonLongPress is issued
            
            Finally two ButtonVeryLongPress received - activate configuration mode.
            turn on buzzer
                Wait for short press
                activate time counting
                wait for released
                Once received, stop counting
                Turn on buzzer
                App goes to Idle state;
    */
} // package Events
