export interface User {
  id: string;
  name: string;
  role: 'Rider' | 'Driver';
  status: 'Active' | 'Suspended' | 'Pending KYC';
}

export interface Trip {
  id: string;
  riderId: string;
  driverId: string | null;
  status: 'Requested' | 'In Progress' | 'Completed' | 'Cancelled';
  fare: number;
}

export interface SupportCase {
  id: string;
  userId: string;
  issue: string;
  status: 'Open' | 'Resolved';
}

export interface RemoteConfigFlag {
  key: string;
  value: any;
  type: 'boolean' | 'string' | 'number';
}

export class MockDatabase {
  private static readonly STORAGE_KEY = 'spotter_admin_db';

  static getInitialData() {
    return {
      users: [
        { id: 'u1', name: 'Alice Smith', role: 'Rider', status: 'Active' },
        { id: 'u2', name: 'Bob Jones', role: 'Driver', status: 'Pending KYC' },
      ] as User[],
      trips: [
        { id: 't1', riderId: 'u1', driverId: null, status: 'Requested', fare: 25.5 },
      ] as Trip[],
      supportCases: [
        { id: 's1', userId: 'u1', issue: 'Driver never arrived', status: 'Open' },
      ] as SupportCase[],
      remoteConfigs: [
        { key: 'show_promo_banner', value: true, type: 'boolean' },
        { key: 'promo_banner_text', value: 'Get 20% off your next ride!', type: 'string' },
        { key: 'maintenance_mode', value: false, type: 'boolean' },
        { key: 'show_offers', value: true, type: 'boolean' },
        { key: 'offer_title', value: '20% off your next trip', type: 'string' },
        { key: 'offer_subtitle', value: 'Use code SPOTT20. Max discount ₹100.', type: 'string' },
      ] as RemoteConfigFlag[],
    };
  }

  static loadData() {
    const data = localStorage.getItem(this.STORAGE_KEY);
    if (!data) {
      const initial = this.getInitialData();
      this.saveData(initial);
      return initial;
    }
    return JSON.parse(data) as ReturnType<typeof MockDatabase.getInitialData>;
  }

  static saveData(data: any) {
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
  }
}
