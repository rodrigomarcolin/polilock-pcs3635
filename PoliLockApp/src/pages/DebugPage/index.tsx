import {
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonTitle,
  IonToolbar,
} from "@ionic/react";

import ConnectionIndicator from "../../components/ConnectionIndicator";

import styles from "./DebugPage.module.css";
import { cafe } from "ionicons/icons";
import { useMqtt } from "../../contexts/MqttContext";

const DebugPage: React.FC = () => {
  const { client } = useMqtt();

  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>DEBUG</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent className={"ion-padding ion-margin"} fullscreen>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">DEBUG</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonToolbar className={styles.footerToolbar}>
          <IonTitle size="small" className={styles.footerText}>
            proceda com cuidado, apenas para programadores
            <IonIcon icon={cafe} className={styles.textIcon} />
          </IonTitle>
        </IonToolbar>
        <ConnectionIndicator isConnected={client?.connected} />
      </IonContent>
    </IonPage>
  );
};

export default DebugPage;
