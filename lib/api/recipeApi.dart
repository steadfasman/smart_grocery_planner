import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = "AIzaSyADHEsUsQABvpdq-z9koHlMiGh_g34-UF0";
const endpoint =
    "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$apiKey";

Future<String> getCookingAssistantResponse({
  required String dishName,
  required String sideDishName,
  required int dishServings,
  required int sideDishServings,
  String? userNotes,
}) async {
  String userPrompt = """
You are a helpful cooking assistant. I need to prepare a main dish and a side dish.

Main Dish: $dishName (Servings: $dishServings)
Side Dish: $sideDishName (Servings: $sideDishServings)
""";

  if ((userNotes ?? "").trim().isNotEmpty) {
    userPrompt += "\n\n💡 Notes: ${userNotes!.trim()}";
  }

  userPrompt += """

Your task has two parts:

---

**PART 1: Recipes**

Give me the recipe for both dishes. For each recipe, include:

- A short description
- Ingredients with quantities (scaled to servings)
- Cooking instructions

---

**PART 2: Grocery List**

Now based on the exact ingredients and amounts in the recipes above, generate a grocery list.

Follow these formatting rules:

1. Include **all ingredients** used in both dishes.
2. Quantities must be **scaled to the given servings**.
3. For each item, show:
   - The **nearest retail quantity** (like 250g, 1 pack, etc.)
   - The **actual amount needed** in brackets.

✅ Example:
🧾 Grocery List (for 4 servings of Idly and 2 servings of Coconut Chutney):

1. Rice: 1 kg (Needed: 850g)
2. Urad Dal: 500g (Needed: 400g)
3. Salt: 1 pack (Needed: 10g)

---

Begin output with the recipes, then the shopping list.
also generate only plain text and send me because I am going to display it as it is , no need any symbols use new lines
and spacing to show difference 
""";

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userPrompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.8,
        "topK": 64,
        "topP": 0.95,
        "maxOutputTokens": 4096
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'];
    return text;
  } else {
    throw Exception('Failed to get response: ${response.body}');
  }
}

Future<String> getCookingAssistantResponseMulti({
  required List<String> mainDishes,
  required List<String> sideDishes,
  required int servings,
  String? userNotes,
}) async {
  String userPrompt = """
You are a helpful cooking assistant. I need to prepare multiple main dishes and side dishes.

Main Dishes:
${mainDishes.map((d) => "- $d (Servings: $servings)").join('\n')}

Side Dishes:
${sideDishes.map((d) => "- $d (Servings: $servings)").join('\n')}
""";

  if ((userNotes ?? "").trim().isNotEmpty) {
    userPrompt += "\n\nNotes: ${userNotes!.trim()}";
  }

  userPrompt += """

Your task has two parts:

PART 1: Recipes

Give me the recipe for each dish. For each recipe, include:

- A short description
- Ingredients with quantities (scaled to servings)
- Cooking instructions

PART 2: Grocery List

Based on the ingredients and quantities used, generate a grocery list.

Requirements:

- Show total needed quantity for each unique item
- Retail quantity (like 250g, 1 pack) followed by (Needed: X)
- Only plain text
- Use new lines and indentation to separate clearly
- No symbols, emojis, or bullets
""";

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userPrompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.8,
        "topK": 64,
        "topP": 0.95,
        "maxOutputTokens": 4096
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final text = data['candidates'][0]['content']['parts'][0]['text'];
    return text;
  } else {
    throw Exception('Failed to get response: ${response.body}');
  }
}

