import {
  IonContent,
  IonHeader,
  IonIcon,
  IonPage,
  IonTitle,
  IonToolbar,
} from "@ionic/react";

import styles from "./DebugPage.module.css";
import { cafe } from "ionicons/icons";

const DebugPage: React.FC = () => {
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
      </IonContent>
    </IonPage>
  );
};

export default DebugPage;
