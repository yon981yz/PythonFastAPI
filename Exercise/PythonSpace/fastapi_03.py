from fastapi import FastAPI
from items import router as items_router

app = FastAPI()
app.include_router(items_router, prefix="/items", tags=["items"])

if __name__=="__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)