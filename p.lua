local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MainEvent = ReplicatedStorage.MainEvent
local codes = {
    "Duck",
    "Watch",
    "VALENTINES2025",
    "BLOSSOM",
    "Beary",
    "ShortCake",
    "SHRIMP",
    "VIP",
    "2025",
    "GIFT24",
    "BenoxaHouse24",
    "HOODMAS24",
    "TRADEME!",
    "HALLOWEEN2024",
    "DACARNIVAL",
    "Ruby",
    "pumpkins2023"
}

for _, code in codes do
    MainEvent:FireServer("EnterPromoCode", code)
    task.wait(10)
end
