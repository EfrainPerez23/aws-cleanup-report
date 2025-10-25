from typing import Final, Dict
from logging import (
    getLogger,
    INFO,
    DEBUG,
    WARNING,
    ERROR,
    CRITICAL,
    Logger,
    StreamHandler,
    Formatter,
    LogRecord,
)


class ColorFormatter(Formatter):
    COLORS: Final[Dict[int, str]] = {
        DEBUG: "\033[1;94m",  # Blue
        INFO: "\033[1;92m",  # Green
        WARNING: "\033[1;93m",  # Yellow
        ERROR: "\033[1;91m",  # Red
        CRITICAL: "\033[1;95m",  # Purple
    }
    RESET: Final[str] = "\033[0m"
    BOLD: Final[str] = "\033[1m"

    def format(self, record: LogRecord) -> str:
        level_color: Final[str] = self.COLORS.get(record.levelno, self.RESET)
        record.levelname = f"{level_color}{record.levelname}{self.RESET}"
        original_msg: Final[str] = super().format(record)
        if record.msg:
            formatted_msg: Final[str] = original_msg.replace(
                record.getMessage(), f"{self.BOLD}{record.getMessage()}{self.RESET}"
            )
            return formatted_msg
        return original_msg


LOGGER: Final[Logger] = getLogger("CLEANUP_LOGGER")
LOGGER.setLevel(DEBUG)
LOGGER.propagate = False

if not LOGGER.handlers:
    handler: Final[StreamHandler] = StreamHandler()
    formatter: Final[ColorFormatter] = ColorFormatter(
        "%(asctime)s - %(levelname)s - %(message)s", "%H:%M:%S"
    )
    handler.setFormatter(formatter)
    LOGGER.addHandler(handler)
