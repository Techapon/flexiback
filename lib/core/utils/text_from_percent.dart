String textGoodFromPercent(int percent) {
  if (percent >= 80) {
    return "good job,";
  } else if (percent >= 60) {
    return "great";
  } else if (percent >= 40) {
    return "not bad";
  } else {
    return "need to improve,keep going💪🔥";
  }
}

String textBadFromPercent(int percent) {
  if (percent >= 80) {
    return "need to improve,keep going💪🔥";
  } else if (percent >= 50) {
    return "not bad";
  } else if (percent >= 40) {
    return "great";
  } else {
    return "good job";
  }
}