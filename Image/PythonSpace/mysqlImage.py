"""
author : changbin an
Description : 
Date : 25/09/2024
Usage : upload file
"""

from fastapi import FastAPI, File, UploadFile
from fastapi.responses import FileResponse
import pymysql
import os ### 이동할때 사용
import shutil ## 파일을 카피 압축등을 할때 사용

app = FastAPI()

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.post("/upload")
async def upload_file(file:UploadFile=File(...)):
    try:
        file_path = os.path.join(UPLOAD_FOLDER, file.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {'result':'OK'}
    except Exception as e:
        print("Error", e)
        return({'result':'Error'})

def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='image',
        charset='utf8'
    )
    return conn

@app.get("/insert")
async def insert(name: str=None, phone: str=None, address: str=None, relation: str=None, filename: str=None):
    conn = connect()
    curs = conn.cursor()

    try: 
        sql = "insert into address(name, phone, address, relation, filename) values (%s,%s,%s,%s,%s)"
        curs.execute(sql,(name, phone, address, relation, filename))
        conn.commit()
        conn.close()
        return{'result':'OK'}
    
    except Exception as e:
        conn.close()
        print("Error", e)
        return({'result':'Error'})

@app.get("/update")
async def insert(name: str=None, phone: str=None, address: str=None, relation: str=None, seq: str=None):
    conn = connect()
    curs = conn.cursor()

    try: 
        sql = "update address set name=%s, phone=%s, address=%s, relation=%s where seq=%s"
        curs.execute(sql,(name, phone, address, relation, seq))
        conn.commit()
        conn.close()
        return{'result':'OK'}
    
    except Exception as e:
        conn.close()
        print("Error", e)
        return({'result':'Error'})
    
@app.get("/updateAll")
async def insert(name: str=None, phone: str=None, address: str=None, relation: str=None, filename: str=None, seq: str=None):
    conn = connect()
    curs = conn.cursor()

    try: 
        sql = "update address set name=%s, phone=%s, address=%s, relation=%s, filename=%s where seq=%s"
        curs.execute(sql,(name, phone, address, relation, filename, seq))
        conn.commit()
        conn.close()
        return{'result':'OK'}
    
    except Exception as e:
        conn.close()
        print("Error", e)
        return({'result':'Error'})
    
@app.get("/select")
async def select():
    conn = connect()
    curs = conn.cursor()

    sql = 'select seq, name, phone, address, relation, filename from address order by name'
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    print(rows)

    return{'results' : rows}

@app.get("/view/{file_name}")
async def get_file(file_name: str):
    file_path = os.path.join(UPLOAD_FOLDER, file_name)
    if os.path.exists(file_path):
        return FileResponse(path=file_path, filename=file_name)
    return {'result' : 'error'}

@app.get("/deleteFile/{file_name}")
async def delete_file(file_name: str):
    try:
        file_path = os.path.join(UPLOAD_FOLDER, file_name)
        if os.path.exists(file_path):
            os.remove(file_path)
        return {'result': "OK"}
    except Exception as e:
        print("Error", e)
        return({'result':'Error'})

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host='127.0.0.1', port=8000)