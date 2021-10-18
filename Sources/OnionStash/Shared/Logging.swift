import Chronicle

public enum LoggingConfiguration {
  public static var formatter: ChronicleFormatter?
  public static var handler: ChronicleHandler?
}

let chrono: Chronicle = Chronicle(
  label: "🧅",
  formatter: LoggingConfiguration.formatter ?? Chronicle.DefaultFormatters.DefaultFormatter(),
  handler: LoggingConfiguration.handler ?? Chronicle.DefaultHandlers.PrintHandler()
)
