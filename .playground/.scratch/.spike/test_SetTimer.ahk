#Requires AutoHotkey v2.0

counter := SecondCounter()
counter.Start
Sleep 5000
counter.Stop
Sleep 2000

; An example class for counting the seconds...
class SecondCounter {
    __New() {
        this.interval := 1000
        this.count := 0
        ; Tick() has an implicit parameter "this" which is a reference to
        ; the object, so we need to create a function which encapsulates
        ; "this" and the method to call:
        this.timer := ObjBindMethod(this, "Tick")
    }
    Start() {
        SetTimer this.timer, this.interval
        ToolTip "Counter started"
    }
    Stop() {
        ; To turn off the timer, we must pass the same object as before:
        SetTimer this.timer, 0
        ToolTip "Counter stopped at " this.count
    }
    ; In this example, the timer calls this method:
    Tick() {
        ToolTip ++this.count
    }
}