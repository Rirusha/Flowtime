/* WorkTimer.vala
 *
 * Copyright 2021 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Flowtime {
    public class WorkTimer : Timer, GLib.Object {
        public bool running { get; set; }
        public bool keep_running { get; set; }
        public bool already_started { get; private set; }
        public bool stoppable { get; private set; }

        public uint seconds { get; private set; }
        public uint minutes { get; private set; }

        /* Signals */
        public void start () {
            running = true;
            keep_running = true;
            already_started = true;
            Timeout.add_seconds (1, update_time);
        }

        private bool update_time () {
            if (!running) {
                return false;
            }

            seconds++;
            message (format_time ());
            updated (format_time ());

            return keep_running;
        }

        public void reset_time () {
            stop ();
            seconds = 0;
            minutes = 0;
            updated (format_time ());
        }

        private string format_time () {
            string seconds_format, minutes_format;
            if (seconds == 60) {
                minutes++;
                seconds = 0;
            }

            if (seconds < 10) {
                seconds_format = "0%u".printf (seconds);
            }
            else {
                seconds_format = "%u".printf (seconds);
            }

            if (minutes < 10) {
                minutes_format = "0%u".printf (minutes);
            }
            else {
                minutes_format = "%u".printf (minutes);
            }

            var format = "%s:%s".printf (minutes_format, seconds_format);
            return format;
        }
    }
}