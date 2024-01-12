{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.rice.cava;
in {
  options.rice.cava = with types; {
    enable = mkBoolOpt false "Enable or disable cava";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cava
    ];

    home.extraOptions.xdg = {
      configFile = {
        "cava/config".text = ''
          ## Configuration file for CAVA. Default values are commented out. Use either ';' or '#' for commenting.
          [general]
          # Smoothing mode. Can be 'normal', 'scientific' or 'waves'. DEPRECATED as of 0.6.0
          ; mode = normal

          # Accepts only non-negative values.
          framerate = 90

          # 'autosens' will attempt to decrease sensitivity if the bars peak. 1 = on, 0 = off
          # new as of 0.6.0 autosens of low values (dynamic range)
          # 'overshoot' allows bars to overshoot (in % of terminal height) without initiating autosens. DEPRECATED as of 0.6.0
          ; autosens = 1
          ; overshoot = 10

          # Manual sensitivity in %. If autosens is enabled, this will only be the initial value.
          # 200 means double height. Accepts only non-negative values.
          ; sensitivity = 100

          # The number of bars (0-200). 0 sets it to auto (fill up console).
          # Bars' width and space between bars in number of characters.
          ; bars = 0
          ; bar_width = 2
          ; bar_spacing = 1
          # bar_height is only used for output in "noritake" format
          ; bar_height = 32

          # For SDL width and space between bars is in pixels, defaults are:
          ; bar_width = 20
          ; bar_spacing = 5


          # Lower and higher cutoff frequencies for lowest and highest bars
          # the bandwidth of the visualizer.
          # Note: there is a minimum total bandwidth of 43Mhz x number of bars.
          # Cava will automatically increase the higher cutoff if a too low band is specified.
          ; lower_cutoff_freq = 50
          ; higher_cutoff_freq = 10000


          # Seconds with no input before cava goes to sleep mode. Cava will not perform FFT or drawing and
          # only check for input once per second. Cava will wake up once input is detected. 0 = disable.
          ; sleep_timer = 0


          [input]

          # Audio capturing method. Possible methods are: 'pulse', 'alsa', 'fifo', 'sndio' or 'shmem'
          # Defaults to 'pulse', 'alsa' or 'fifo', in that order, dependent on what support cava was built with.
          #
          # All input methods uses the same config variable 'source'
          # to define where it should get the audio.
          #
          # For pulseaudio 'source' will be the source. Default: 'auto', which uses the monitor source of the default sink
          # (all pulseaudio sinks(outputs) have 'monitor' sources(inputs) associated with them).
          #
          # For alsa 'source' will be the capture device.
          # For fifo 'source' will be the path to fifo-file.
          # For shmem 'source' will be /squeezelite-AA:BB:CC:DD:EE:FF where 'AA:BB:CC:DD:EE:FF' will be squeezelite's MAC address
          ; method = pulse
          ; source = auto

          ; method = alsa
          ; source = hw:Loopback,1

          ; method = fifo
          ; source = /tmp/mpd.fifo
          ; sample_rate = 44100
          ; sample_bits = 16

          ; method = shmem
          ; source = /squeezelite-AA:BB:CC:DD:EE:FF

          ; method = portaudio
          ; source = auto


          [output]

          # Output method. Can be 'ncurses', 'noncurses', 'raw', 'noritake' or 'sdl'.
          # 'noncurses' uses a custom framebuffer technique and prints only changes
          # from frame to frame in the terminal. 'ncurses' is default if supported.
          #
          # 'raw' is an 8 or 16 bit (configurable via the 'bit_format' option) data
          # stream of the bar heights that can be used to send to other applications.
          # 'raw' defaults to 200 bars, which can be adjusted in the 'bars' option above.
          #
          # 'noritake' outputs a bitmap in the format expected by a Noritake VFD display
          #  in graphic mode. It only support the 3000 series graphical VFDs for now.
          #
          # 'sdl' uses the Simple DirectMedia Layer to render in a graphical context.
          ; method = ncurses

          # Visual channels. Can be 'stereo' or 'mono'.
          # 'stereo' mirrors both channels with low frequencies in center.
          # 'mono' outputs left to right lowest to highest frequencies.
          # 'mono_option' set mono to either take input from 'left', 'right' or 'average'.
          # set 'reverse' to 1 to display frequencies the other way around.
          ; channels = stereo
          ; mono_option = average
          ; reverse = 0

          # Raw output target. A fifo will be created if target does not exist.
          ; raw_target = /dev/stdout

          # Raw data format. Can be 'binary' or 'ascii'.
          ; data_format = binary

          # Binary bit format, can be '8bit' (0-255) or '16bit' (0-65530).
          ; bit_format = 16bit

          # Ascii max value. In 'ascii' mode range will run from 0 to value specified here
          ; ascii_max_range = 1000

          # Ascii delimiters. In ascii format each bar and frame is separated by a delimiters.
          # Use decimal value in ascii table (i.e. 59 = ';' and 10 = '\n' (line feed)).
          ; bar_delimiter = 59
          ; frame_delimiter = 10

          # sdl window size and position. -1,-1 is centered.
          ; sdl_width = 1000
          ; sdl_height = 500
          ; sdl_x = -1
          ; sdl_y= -1

          [color]

          # default is to keep current terminal color
          ; background = default
          ; foreground = default

          # SDL only support hex code colors, these are the default:
          ; background = '#111111'
          foreground = '#E6ECFE'


          # Gradient mode, only hex defined colors (and thereby ncurses mode) are supported,
          # background must also be defined in hex  or remain commented out. 1 = on, 0 = off.
          # You can define as many as 8 different colors. They range from bottom to top of screen
          gradient = 1
          gradient_count = 4

          gradient_color_1 = '#8aadf4'
          gradient_color_2 = '#7dc4e4'
          gradient_color_3 = '#91d7e3'
          gradient_color_4 = '#cad3f5'
          gradient_color_5 = '#c6a0f6'
          gradient_color_6 = '#f5bde6'
          gradient_color_7 = '#ee99a0'
          gradient_color_8 = '#ed8796'



          [smoothing]

          # Percentage value for integral smoothing. Takes values from 0 - 100.
          # Higher values means smoother, but less precise. 0 to disable.
          # DEPRECATED as of 0.8.0, use noise_reduction instead
          ; integral = 77

          # Disables or enables the so-called "Monstercat smoothing" with or without "waves". Set to 0 to disable.
          ; monstercat = 0
          ; waves = 0

          # Set gravity percentage for "drop off". Higher values means bars will drop faster.
          # Accepts only non-negative values. 50 means half gravity, 200 means double. Set to 0 to disable "drop off".
          # DEPRECATED as of 0.8.0, use noise_reduction instead
          ; gravity = 100


          # In bar height, bars that would have been lower that this will not be drawn.
          # DEPRECATED as of 0.8.0
          ; ignore = 0

          # Noise reduction, float 0 - 1. default 0.77
          # the raw visualization is very noisy, this factor adjusts the integral and gravity filters to keep the signal smooth
          # 1 will be very slow and smooth, 0 will be fast but noisy.
          ; noise_reduction = 0.99


          [eq]

          # This one is tricky. You can have as much keys as you want.
          # Remember to uncomment more then one key! More keys = more precision.
          # Look at readme.md on github for further explanations and examples.
          # DEPRECATED as of 0.8.0 can be brought back by popular request, open issue at:
          # https://github.com/karlstav/cava
          ; 1 = 1 # bass
          ; 2 = 1
          ; 3 = 1 # midtone
          ; 4 = 1
          ; 5 = 1 # treble
        '';
        "cava/catppuccin-config".text = ''
          ## Configuration file for CAVA. Default values are commented out. Use either ';' or '#' for commenting.


          [general]

          # Smoothing mode. Can be 'normal', 'scientific' or 'waves'. DEPRECATED as of 0.6.0
          ; mode = normal

          # Accepts only non-negative values.
          framerate = 90

          # 'autosens' will attempt to decrease sensitivity if the bars peak. 1 = on, 0 = off
          # new as of 0.6.0 autosens of low values (dynamic range)
          # 'overshoot' allows bars to overshoot (in % of terminal height) without initiating autosens. DEPRECATED as of 0.6.0
          ; autosens = 1
          ; overshoot = 10

          # Manual sensitivity in %. If autosens is enabled, this will only be the initial value.
          # 200 means double height. Accepts only non-negative values.
          ; sensitivity = 100

          # The number of bars (0-200). 0 sets it to auto (fill up console).
          # Bars' width and space between bars in number of characters.
          ; bars = 0
          ; bar_width = 2
          ; bar_spacing = 1
          # bar_height is only used for output in "noritake" format
          ; bar_height = 32

          # For SDL width and space between bars is in pixels, defaults are:
          ; bar_width = 20
          ; bar_spacing = 5


          # Lower and higher cutoff frequencies for lowest and highest bars
          # the bandwidth of the visualizer.
          # Note: there is a minimum total bandwidth of 43Mhz x number of bars.
          # Cava will automatically increase the higher cutoff if a too low band is specified.
          ; lower_cutoff_freq = 50
          ; higher_cutoff_freq = 10000


          # Seconds with no input before cava goes to sleep mode. Cava will not perform FFT or drawing and
          # only check for input once per second. Cava will wake up once input is detected. 0 = disable.
          ; sleep_timer = 0


          [input]

          # Audio capturing method. Possible methods are: 'pulse', 'alsa', 'fifo', 'sndio' or 'shmem'
          # Defaults to 'pulse', 'alsa' or 'fifo', in that order, dependent on what support cava was built with.
          #
          # All input methods uses the same config variable 'source'
          # to define where it should get the audio.
          #
          # For pulseaudio 'source' will be the source. Default: 'auto', which uses the monitor source of the default sink
          # (all pulseaudio sinks(outputs) have 'monitor' sources(inputs) associated with them).
          #
          # For alsa 'source' will be the capture device.
          # For fifo 'source' will be the path to fifo-file.
          # For shmem 'source' will be /squeezelite-AA:BB:CC:DD:EE:FF where 'AA:BB:CC:DD:EE:FF' will be squeezelite's MAC address
          ; method = pulse
          ; source = auto

          ; method = alsa
          ; source = hw:Loopback,1

          ; method = fifo
          ; source = /tmp/mpd.fifo
          ; sample_rate = 44100
          ; sample_bits = 16

          ; method = shmem
          ; source = /squeezelite-AA:BB:CC:DD:EE:FF

          ; method = portaudio
          ; source = auto


          [output]

          # Output method. Can be 'ncurses', 'noncurses', 'raw', 'noritake' or 'sdl'.
          # 'noncurses' uses a custom framebuffer technique and prints only changes
          # from frame to frame in the terminal. 'ncurses' is default if supported.
          #
          # 'raw' is an 8 or 16 bit (configurable via the 'bit_format' option) data
          # stream of the bar heights that can be used to send to other applications.
          # 'raw' defaults to 200 bars, which can be adjusted in the 'bars' option above.
          #
          # 'noritake' outputs a bitmap in the format expected by a Noritake VFD display
          #  in graphic mode. It only support the 3000 series graphical VFDs for now.
          #
          # 'sdl' uses the Simple DirectMedia Layer to render in a graphical context.
          ; method = ncurses

          # Visual channels. Can be 'stereo' or 'mono'.
          # 'stereo' mirrors both channels with low frequencies in center.
          # 'mono' outputs left to right lowest to highest frequencies.
          # 'mono_option' set mono to either take input from 'left', 'right' or 'average'.
          # set 'reverse' to 1 to display frequencies the other way around.
          ; channels = stereo
          ; mono_option = average
          ; reverse = 0

          # Raw output target. A fifo will be created if target does not exist.
          ; raw_target = /dev/stdout

          # Raw data format. Can be 'binary' or 'ascii'.
          ; data_format = binary

          # Binary bit format, can be '8bit' (0-255) or '16bit' (0-65530).
          ; bit_format = 16bit

          # Ascii max value. In 'ascii' mode range will run from 0 to value specified here
          ; ascii_max_range = 1000

          # Ascii delimiters. In ascii format each bar and frame is separated by a delimiters.
          # Use decimal value in ascii table (i.e. 59 = ';' and 10 = '\n' (line feed)).
          ; bar_delimiter = 59
          ; frame_delimiter = 10

          # sdl window size and position. -1,-1 is centered.
          ; sdl_width = 1000
          ; sdl_height = 500
          ; sdl_x = -1
          ; sdl_y= -1

          [color]

          # default is to keep current terminal color
          ; background = default
          ; foreground = default

          # SDL only support hex code colors, these are the default:
          ; background = '#111111'
          foreground = '#E6ECFE'


          # Gradient mode, only hex defined colors (and thereby ncurses mode) are supported,
          # background must also be defined in hex  or remain commented out. 1 = on, 0 = off.
          # You can define as many as 8 different colors. They range from bottom to top of screen
          gradient = 1
          gradient_count = 4

          gradient_color_1 = '#8aadf4'
          gradient_color_2 = '#7dc4e4'
          gradient_color_3 = '#91d7e3'
          gradient_color_4 = '#cad3f5'
          gradient_color_5 = '#c6a0f6'
          gradient_color_6 = '#f5bde6'
          gradient_color_7 = '#ee99a0'
          gradient_color_8 = '#ed8796'



          [smoothing]

          # Percentage value for integral smoothing. Takes values from 0 - 100.
          # Higher values means smoother, but less precise. 0 to disable.
          # DEPRECATED as of 0.8.0, use noise_reduction instead
          ; integral = 77

          # Disables or enables the so-called "Monstercat smoothing" with or without "waves". Set to 0 to disable.
          ; monstercat = 0
          ; waves = 0

          # Set gravity percentage for "drop off". Higher values means bars will drop faster.
          # Accepts only non-negative values. 50 means half gravity, 200 means double. Set to 0 to disable "drop off".
          # DEPRECATED as of 0.8.0, use noise_reduction instead
          ; gravity = 100


          # In bar height, bars that would have been lower that this will not be drawn.
          # DEPRECATED as of 0.8.0
          ; ignore = 0

          # Noise reduction, float 0 - 1. default 0.77
          # the raw visualization is very noisy, this factor adjusts the integral and gravity filters to keep the signal smooth
          # 1 will be very slow and smooth, 0 will be fast but noisy.
          ; noise_reduction = 0.99


          [eq]

          # This one is tricky. You can have as much keys as you want.
          # Remember to uncomment more then one key! More keys = more precision.
          # Look at readme.md on github for further explanations and examples.
          # DEPRECATED as of 0.8.0 can be brought back by popular request, open issue at:
          # https://github.com/karlstav/cava
          ; 1 = 1 # bass
          ; 2 = 1
          ; 3 = 1 # midtone
          ; 4 = 1
          ; 5 = 1 # treble
        '';
        "cava/iceberg-config".text = ''
            ## Configuration file for CAVA. Default values are commented out. Use either ';' or '#' for commenting.


          [general]

          # Smoothing mode. Can be 'normal', 'scientific' or 'waves'. DEPRECATED as of 0.6.0
          ; mode = normal

          # Accepts only non-negative values.
          framerate = 90

          # 'autosens' will attempt to decrease sensitivity if the bars peak. 1 = on, 0 = off
          # new as of 0.6.0 autosens of low values (dynamic range)
          # 'overshoot' allows bars to overshoot (in % of terminal height) without initiating autosens. DEPRECATED as of 0.6.0
          ; autosens = 1
          ; overshoot = 10

          # Manual sensitivity in %. If autosens is enabled, this will only be the initial value.
          # 200 means double height. Accepts only non-negative values.
          ; sensitivity = 100

          # The number of bars (0-200). 0 sets it to auto (fill up console).
          # Bars' width and space between bars in number of characters.
          ; bars = 0
          ; bar_width = 2
          ; bar_spacing = 1
          # bar_height is only used for output in "noritake" format
          ; bar_height = 32

          # For SDL width and space between bars is in pixels, defaults are:
          ; bar_width = 20
          ; bar_spacing = 5


          # Lower and higher cutoff frequencies for lowest and highest bars
          # the bandwidth of the visualizer.
          # Note: there is a minimum total bandwidth of 43Mhz x number of bars.
          # Cava will automatically increase the higher cutoff if a too low band is specified.
          ; lower_cutoff_freq = 50
          ; higher_cutoff_freq = 10000


          # Seconds with no input before cava goes to sleep mode. Cava will not perform FFT or drawing and
          # only check for input once per second. Cava will wake up once input is detected. 0 = disable.
          ; sleep_timer = 0


          [input]

          # Audio capturing method. Possible methods are: 'pulse', 'alsa', 'fifo', 'sndio' or 'shmem'
          # Defaults to 'pulse', 'alsa' or 'fifo', in that order, dependent on what support cava was built with.
          #
          # All input methods uses the same config variable 'source'
          # to define where it should get the audio.
          #
          # For pulseaudio 'source' will be the source. Default: 'auto', which uses the monitor source of the default sink
          # (all pulseaudio sinks(outputs) have 'monitor' sources(inputs) associated with them).
          #
          # For alsa 'source' will be the capture device.
          # For fifo 'source' will be the path to fifo-file.
          # For shmem 'source' will be /squeezelite-AA:BB:CC:DD:EE:FF where 'AA:BB:CC:DD:EE:FF' will be squeezelite's MAC address
          ; method = pulse
          ; source = auto

          ; method = alsa
          ; source = hw:Loopback,1

          ; method = fifo
          ; source = /tmp/mpd.fifo
          ; sample_rate = 44100
          ; sample_bits = 16

          ; method = shmem
          ; source = /squeezelite-AA:BB:CC:DD:EE:FF

          ; method = portaudio
          ; source = auto


          [output]

          # Output method. Can be 'ncurses', 'noncurses', 'raw', 'noritake' or 'sdl'.
          # 'noncurses' uses a custom framebuffer technique and prints only changes
          # from frame to frame in the terminal. 'ncurses' is default if supported.
          #
          # 'raw' is an 8 or 16 bit (configurable via the 'bit_format' option) data
          # stream of the bar heights that can be used to send to other applications.
          # 'raw' defaults to 200 bars, which can be adjusted in the 'bars' option above.
          #
          # 'noritake' outputs a bitmap in the format expected by a Noritake VFD display
          #  in graphic mode. It only support the 3000 series graphical VFDs for now.
          #
          # 'sdl' uses the Simple DirectMedia Layer to render in a graphical context.
          ; method = ncurses

          # Visual channels. Can be 'stereo' or 'mono'.
          # 'stereo' mirrors both channels with low frequencies in center.
          # 'mono' outputs left to right lowest to highest frequencies.
          # 'mono_option' set mono to either take input from 'left', 'right' or 'average'.
          # set 'reverse' to 1 to display frequencies the other way around.
          ; channels = stereo
          ; mono_option = average
          ; reverse = 0

          # Raw output target. A fifo will be created if target does not exist.
          ; raw_target = /dev/stdout

          # Raw data format. Can be 'binary' or 'ascii'.
          ; data_format = binary

          # Binary bit format, can be '8bit' (0-255) or '16bit' (0-65530).
          ; bit_format = 16bit

          # Ascii max value. In 'ascii' mode range will run from 0 to value specified here
          ; ascii_max_range = 1000

          # Ascii delimiters. In ascii format each bar and frame is separated by a delimiters.
          # Use decimal value in ascii table (i.e. 59 = ';' and 10 = '\n' (line feed)).
          ; bar_delimiter = 59
          ; frame_delimiter = 10

          # sdl window size and position. -1,-1 is centered.
          ; sdl_width = 1000
          ; sdl_height = 500
          ; sdl_x = -1
          ; sdl_y= -1

          [color]

          # default is to keep current terminal color
          ; background = default
          ; foreground = default

          # SDL only support hex code colors, these are the default:
          ; background = '#111111'
          foreground = '#E6ECFE'


          # Gradient mode, only hex defined colors (and thereby ncurses mode) are supported,
          # background must also be defined in hex  or remain commented out. 1 = on, 0 = off.
          # You can define as many as 8 different colors. They range from bottom to top of screen
          gradient = 1
          gradient_count = 4

          gradient_color_1 = '#44526f'
          gradient_color_2 = '#4e5e7e'
          gradient_color_3 = '#576a8e'
          gradient_color_4 = '#61759e'
          gradient_color_5 = '#7183a8'
          gradient_color_6 = '#7486a9'
          gradient_color_7 = '#8191b1'
          gradient_color_8 = '#909fbb'



          [smoothing]

          # Percentage value for integral smoothing. Takes values from 0 - 100.
          # Higher values means smoother, but less precise. 0 to disable.
          # DEPRECATED as of 0.8.0, use noise_reduction instead
          ; integral = 77

          # Disables or enables the so-called "Monstercat smoothing" with or without "waves". Set to 0 to disable.
          ; monstercat = 0
          ; waves = 0

          # Set gravity percentage for "drop off". Higher values means bars will drop faster.
          # Accepts only non-negative values. 50 means half gravity, 200 means double. Set to 0 to disable "drop off".
          # DEPRECATED as of 0.8.0, use noise_reduction instead
          ; gravity = 100


          # In bar height, bars that would have been lower that this will not be drawn.
          # DEPRECATED as of 0.8.0
          ; ignore = 0

          # Noise reduction, float 0 - 1. default 0.77
          # the raw visualization is very noisy, this factor adjusts the integral and gravity filters to keep the signal smooth
          # 1 will be very slow and smooth, 0 will be fast but noisy.
          ; noise_reduction = 0.99


          [eq]

          # This one is tricky. You can have as much keys as you want.
          # Remember to uncomment more then one key! More keys = more precision.
          # Look at readme.md on github for further explanations and examples.
          # DEPRECATED as of 0.8.0 can be brought back by popular request, open issue at:
          # https://github.com/karlstav/cava
          ; 1 = 1 # bass
          ; 2 = 1
          ; 3 = 1 # midtone
          ; 4 = 1
          ; 5 = 1 # treble
        '';
      };
    };
  };
}
