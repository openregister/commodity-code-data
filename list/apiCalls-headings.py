import requests, json
# x = "0101"
# s = f"https://www.trade-tariff.service.gov.uk/trade-tariff/headings/{x}.json"
# print(s)

# x = ["0101", "0201", "0202", "0203"]
# for i in x:
#     print(f"https://www.trade-tariff.service.gov.uk/trade-tariff/headings/{x}.json")


# for i in ["0101", "0201", "0202", "0203"]:
#     print(f"https://www.trade-tariff.service.gov.uk/trade-tariff/headings/{i}.json")

endpoint = "https://www.trade-tariff.service.gov.uk/trade-tariff/headings/0101.json"

xx = json.loads(requests.get(endpoint).text)

print(xx)