from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def read_items():
    return {"message" : "Read all itmes"}

@router.get("/{itemId}")
async def read_itme(itemId: int):
    return{"item_id" : itemId}
