import json
from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher


class ActionMenu(Action):

    def name(self) -> Text:
        return "action_menu"

    def run(self, dispatcher: "CollectingDispatcher", tracker: Tracker, domain: Dict[Text, Any]) -> List[
        Dict[Text, Any]]:
        file = open("menu.json")
        data = json.load(file)
        for meal in data['items']:
            dispatcher.utter_message("Meal: " + meal['name'] + ", price: " + str(meal['price']))
        return []


class ActionOrder(Action):

    def name(self) -> Text:
        return "action_order"

    def run(self, dispatcher: "CollectingDispatcher", tracker: Tracker, domain: Dict[Text, Any]) -> List[
        Dict[Text, Any]]:
        file = open("menu.json")
        data = json.load(file)
        meal = tracker.get_slot("meal")
        for item in data['items']:
            if meal == item['name'] or meal == item['name'].lower():
                dispatcher.utter_message("Your order will be ready after " + str(float(item['preparation_time']) * 60)
                                         + " minutes, price is: " + str(item['price']))

        return []


class ActionOpen(Action):

    def name(self) -> Text:
        return "action_open"

    def run(self, dispatcher: "CollectingDispatcher", tracker: Tracker, domain: Dict[Text, Any]) -> List[
        Dict[Text, Any]]:
        file = open("opening_hours.json")
        data = json.load(file)
        day = tracker.get_slot("day")
        hour = tracker.get_slot("hour")
        converted_hour = self.convert_time(hour)
        if int(data['items'][day]['open']) * 60 <= converted_hour <= int(data['items'][day]['close']) * 60:
            dispatcher.utter_message("Yes, restaurant is open")
        else:
            dispatcher.utter_message("No, restaurant is closed")
        return []

    def convert_time(self, time):
        list = time.split(":")
        return int(list[0]) * 60 + int(list[1])
