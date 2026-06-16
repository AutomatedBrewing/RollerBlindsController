package SystemProcesses {
    private import SystemUseCases::*;
    
    /* Definiujemy proces systemowy jako zachowanie oparte na stanach */
    state machine ShutterMotionControlProcess {
        doc /* Zarządza dozwoloną kolejnością wykonywania procesów ruchu i przerw */
        
        // Stan początkowy - sterownik czuwa
        state idle;
        
        // Stan automatycznego otwierania (Process 1)
        state automaticOpening {
            entry action execOpen : openRollerShutter;
        }
        
        // Stan automatycznego zamykania (Process 2)
        state automaticClosing {
            entry action execClose : closeRollerShutter;
        }
        
        // Stan manualnego pozycjonowania (Process 3 - Long Press)
        state manualPositioningMode {
            entry action execPosition : positionRollerShutter;
        }
        
        /* Definicja przejść (Transitions) realizujących logikę przerw (Process 4) */
        
        // Wyzwalanie procesów automatycznych (Short Press)
        transition idle_to_autoOpen
            first idle then automaticOpening
            on accept shortPressUp;
            
        transition idle_to_autoClose
            first idle then automaticClosing
            on accept shortPressDown;
            
        // Wyzwalanie procesu manualnego (Long Press)
        transition idle_to_manual
            first idle then manualPositioningMode
            on accept longPress;
            
        /* KROK 4 Z TWOJEJ ANALIZY: Global Interrupt Mechanism (Process 4) */
        
        transition autoOpen_interrupted
            first automaticOpening then idle
            on accept stopCommand; // Może pochodzić z Stop Movement UC, czujnika prądu lub przycisku
            
        transition autoClose_interrupted
            first automaticClosing then idle
            on accept stopCommand;
            
        // Koniec procesu manualnego po puszczeniu przycisku
        transition manual_released
            first manualPositioningMode then idle
            on accept buttonReleased;
            
        // Zabezpieczenie czasowe / krańcówka (Brak feedbacku pozycji)
        transition autoMovementFinished
            first (automaticOpening or automaticClosing) then idle
            on accept timeoutExpired; // Kluczowe dla systemów bez feedbacku
    }
}