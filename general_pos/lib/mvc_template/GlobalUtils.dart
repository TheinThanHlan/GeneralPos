class GlobalUtils {
  String fDateTimeToDDMMYY_HMS(DateTime dt) {
    return dt.day.toString() +
        "/" +
        dt.month.toString() +
        "/" +
        dt.year.toString() +
        " " +
        dt.hour.toString() +
        ":" +
        dt.minute.toString() +
        ":" +
        dt.second.toString();
  }
}
