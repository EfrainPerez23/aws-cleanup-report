from logging import getLogger, DEBUG, StreamHandler, Formatter, Logger
from typing import Final

LOGGER: Final[Logger] = getLogger("report-cleanup")
LOGGER.setLevel(DEBUG)
LOGGER.propagate = False

if not LOGGER.handlers:
    handler: Final[StreamHandler] = StreamHandler()
    formatter: Final[Formatter] = Formatter(
        "%(asctime)s - report-cleanup - %(levelname)s - %(message)s", datefmt="%H:%M:%S"
    )
    handler.setFormatter(formatter)
    LOGGER.addHandler(handler)
