from fastapi import FastAPI
from fastapi.responses import JSONResponse
import uvicorn

app = FastAPI()


@app.get("/")
def read_root(name: str = "World"):
    return JSONResponse(content={"message": f"Hello, {name}!"})


@app.get("/health")
def read_health():
    return JSONResponse(content={"message": "healthy"})


def main():
    uvicorn.run(app, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    main()
