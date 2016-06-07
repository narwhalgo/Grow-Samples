class exports.UISound
    constructor: (@src) ->
        @audio = document.createElement("audio")
        @audio.setAttribute("webkit-playsinline", "true")
        @audio.setAttribute("preload", "auto")
        @audio.src = @src
        
    stop: ->
        @audio.pause()
        @audio.currentTime = 0
    play: ->
        @audio.play()
    pause: ->
        @audio.pause()
    currentTime: ->
        return @audio.currentTime
    duration: ->
        return @audio.duration
    formatTimeLeft: ->
        Math.round(@audio.currentTime)
        sec = Math.floor(@audio.duration) - Math.floor(@audio.currentTime)
        min = Math.floor(sec / 60)
        sec = Math.floor(sec % 60)
        sec = if sec >= 10 then sec else '0' + sec
        return "#{min}:#{sec}"
    updateOnTimeUpdate: ->
        @audio.ontimeupdate = @ontimeupdate

