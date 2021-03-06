import gifAnimation.*;

boolean armCreateGif = false;
boolean gifMode = false;
String gifQuery;
Gif gif;
int gifMarkTime = 0;
int gifTimeInterval = 500;
int maxGifResults = 15;
String apiUrl = "https://api.giphy.com/v1/gifs/search?";
String apiKey = "dc6zaTOxFJmzC";
boolean gifSearchEnabled = false;
  
void armGif(String query) {
  gifQuery = query;
  armCreateGif = true;
  gifMarkTime = millis();
}

void createGif() {
  try {
    gif = getSingleGif(gifQuery, maxGifResults);
    gif.loop();
    gif.play();
    gifMode = true;
  } catch (Exception e) {
    gifMode = false;
  }
}

ArrayList<String> getGifUrls(String query, int maxGifResults) {
  ArrayList<String> returns = new ArrayList<String>();
  String queryUrl = apiUrl + "&api_key=" + apiKey + "&q=" + query;
  JSONObject json = loadJSONObject(queryUrl);
  JSONArray data = json.getJSONArray("data");
  
  for (int i=0; i<data.size(); i++) {
    try {
      JSONObject datum = data.getJSONObject(i);
      JSONObject images = datum.getJSONObject("images");
      JSONObject original = images.getJSONObject("original");
      String url = original.getString("url").split("\\?")[0];
      String url2 = "https://i.giphy.com/media/" + url.split("/media/")[1];
      returns.add(url2);
    } catch (Exception e) { }
    if (returns.size() >= maxGifResults) break;
  }
  
  return returns;
}

ArrayList<Gif> getGifArray(String query, int maxGifResults) {
  ArrayList<Gif> returns = new ArrayList<Gif>();
  ArrayList<String> urls = getGifUrls(query, maxGifResults);
  
  for (int i=0; i<urls.size(); i++) {
    try {
      returns.add(new Gif(this, urls.get(i)));
    } catch (Exception e) { }
    if (returns.size() >= maxGifResults) break;
  }
  
  if (returns.size() < 1) gifMode = false;
  return returns;
}

Gif getSingleGif(String query, int maxGifResults) {
  ArrayList<String> urls = getGifUrls(query, maxGifResults);
  Gif returns;
  try {
    returns = new Gif(this, urls.get((int) random(urls.size())));
    return returns;
  } catch (Exception e) {
    returns = null;
    gifMode = false;
  }
  return returns;
}

class GifDictionary {
  
  String[] words;
  
  GifDictionary(String url) {
    words = loadStrings(url);
  }
  
  boolean doSearch(String input) {
    input = input.toLowerCase();
    for (String word : words) {
      if (input.equals(word.toLowerCase())) return true;
    }
    return false;
  }
  
}
