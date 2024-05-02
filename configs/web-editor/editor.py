from flask import Flask, request, render_template
from flask_basicauth import BasicAuth
from os import listdir
import subprocess


app = Flask(__name__)

app.config['BASIC_AUTH_USERNAME'] = 'admin'
app.config['BASIC_AUTH_PASSWORD'] = 'admin'

basic_auth = BasicAuth(app)


@app.route('/reboot-device', methods=['GET', 'POST'])
@basic_auth.required
def reboot_device():
    content = ''
    style = ''
    header = ''
    if request.method == 'POST':
           content = "Reiniciando... (Refresca la página manualmente en unos 60 segundos)"
           style = 'display:none;'
           subprocess.call(["shutdown", "-r", "now"])
    return render_template('reset.html', config_file=content, reload_header=header)



@app.route('/conf-network-cards', methods=['GET', 'POST'])
@basic_auth.required
def conf_network_cards():
    content = ''
    if request.method == 'POST':
           content = request.form['text_box']
           with open('/etc/network/interfaces.d/statics', 'w') as f:
                   f.write(str(content))
    else:
        with open('/etc/network/interfaces.d/statics', 'r') as f2:
            content = f2.read()
            print(content)
    return render_template('index.html', config_file=content)





@app.route('/conf-hostapd', methods=['GET', 'POST'])
@basic_auth.required
def conf_hostapd():
    content = ''
    if request.method == 'POST':
           content = request.form['text_box']
           content = content.replace('\r', '')
           with open('/opt/AP-soft/configs/access_point/hostapd.conf', 'w', encoding="utf-8") as f:
                   f.write(str(content))
                   f.flush()
                   f.close()
    else:
        with open('/opt/AP-soft/configs/access_point/hostapd.conf', 'r') as f2:
            content = f2.read()
            print(content)
    return render_template('index.html', config_file=content)



@app.route('/conf-dnsmasq', methods=['GET', 'POST'])
@basic_auth.required
def conf_dnsmasq():
    content = ''
    if request.method == 'POST':
           content = request.form['text_box']
           content = content.replace('\r', '')
           with open('/opt/AP-soft/configs/access_point/dnsmasq.conf', 'w', encoding="utf-8") as f:
                   f.write(str(content))
                   f.flush()
                   f.close()
    else:
        with open('/opt/AP-soft/configs/access_point/dnsmasq.conf', 'r') as f2:
            content = f2.read()
            print(content)
    return render_template('index.html', config_file=content)





@app.route('/vpn-random-profiles', methods=['GET', 'POST'])
@basic_auth.required
def change_random_profiles():
    content = ''
    profiles_content = listdir('/opt/AP-soft/configs/vpn/profiles/')
    if request.method == 'POST':
           content = request.form['text_box']
           with open('/opt/AP-soft/configs/vpn/vpn_locations.conf', 'w') as f:
                   f.write(str(content))
    else:
        with open('/opt/AP-soft/configs/vpn/vpn_locations.conf', 'r') as f2:
            content = f2.read()
            print(content)
    return render_template('index.html', config_file=content, bool_profiles=True, profiles=profiles_content)



@app.route('/vpn-credenciales', methods=['GET', 'POST'])
@basic_auth.required
def change_config():
    content = ''
    
    if request.method == 'POST':
           content = request.form['text_box']
           with open('/opt/AP-soft/configs/vpn/credentials.vpn', 'w') as f:
                   f.write(str(content))
    else:
        with open('/opt/AP-soft/configs/vpn/credentials.vpn', 'r') as f2:
            content = f2.read()
            print(content)
    return render_template('index.html', config_file=content)



if __name__ == '__main__':
    app.debug = True
    app.run(host="0.0.0.0", port="5000")